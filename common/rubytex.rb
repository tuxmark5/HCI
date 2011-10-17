#! /usr/bin/ruby

class Array
  def collect_inter(sep)
    out = "";
    each_with_index do |v, i|
      xo(sep) if i > 0;
      yield v;
    end;
    return out;
  end;

  def join2(l, s, r)
    "#{l}#{join(s)}#{r}"
  end;
end;

class String
  def xo
    out = gsub("&L", "[").gsub("&R", "]").gsub("&&", "&").gsub("&A", "@");
    $dst.write(" #{out} ");
  end;
end;

class Table
  def initialize
    @align  = [];
    @header = [];
    @widths = [];
    @rows   = [];
  end;

  def with
    yield

    "\\begin{longtable}".xo
    @align.each_index.map do |i|
      '%s{%f\linewidth}' % [@align[i], @widths[i]];
    end.join2('{|', ' | ', "|}\n").xo;

    "\\hline\n".xo
    @rows.each do |row|
      (row + "\n").xo
    end;
    "\\end{longtable}\n".xo
  end;

  def xrow_a(y)
    @align = y;
  end;

  def xrow_h(y)
    @rows << y.map do |cell| 
      "\\multicolumn{1}
      {|>{\\columncolor[gray]{0.8}}c|}
      {\\bf #{cell}}"
    end.join2("", " & ", "\\\\ \\hline");
  end;
  
  def xrow_hh(cell)
    @rows << 
      "\\multicolumn{#{@widths.length}} 
      {|>{\\columncolor[gray]{0.8}}c|}
      {\\bf #{cell}} \\\\ \\hline";
  end;
  
  def xrow_ee(cell)
    @rows << 
      "\\multicolumn{#{@widths.length}}
       {|p{0.96\\linewidth}|}
       {#{cell}} \\\\ \\hline";
  end;

  def xrow_e(y)
    @rows << y.join2("", " & ", "\\\\ \\hline")
  end;

  def xrow_w(y)
    y           = y.map { |x| x.to_f }
    @widthMult  = 1 - 0.025 * y.length;
    sum         = y.inject(:+) / @widthMult;
    @widths     = y.map { |x| x / sum }
  end;
end;

def xtable(src)
  z = src.split(']').map do |line|
    line.split('[', 2).map do |entry|
      entry.strip;
    end;
  end;

  (t = Table.new).with do
    z.reject! { |y| y.length < 2 }
    z.each do |y|
      sep = t.send("xrow_" + y[0], y[1].split('|').map {|x| x.strip});
      "\n".xo
    end;
  end;
end;

def main()
  src  = File.open("dist/input.tmp", "r");
  $dst = File.open("dist/output.tmp", "w");
  fun  = src.readline.strip;
  arg  = src.read.gsub('@', '\\');
  puts "READ: #{arg}"
  send(fun, arg);
  $dst.close
end;

main();

