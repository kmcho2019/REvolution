module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Individual DFF instantiations with explicit delays
dff dff0 (.clk(clk), .d(d[0]), .q(q[0]));
dff dff1 (.clk(clk), .d(d[1]), .q(q[1]));
dff dff2 (.clk(clk), .d(d[2]), .q(q[2]));
dff dff3 (.clk(clk), .d(d[3]), .q(q[3]));
dff dff4 (.clk(clk), .d(d[4]), .q(q[4]));
dff dff5 (.clk(clk), .d(d[5]), .q(q[5]));
dff dff6 (.clk(clk), .d(d[6]), .q(q[6]));
dff dff7 (.clk(clk), .d(d[7]), .q(q[7]));

endmodule

// DFF primitive with timing control
primitive dff (q, clk, d);
output q;
input clk, d;
reg q;

table
// clk  d  :  q  :  q+
   (01) 0  :  ?  :  0;
   (01) 1  :  ?  :  1;
   (1?) ?  :  ?  :  -;  // ignore negative clock edges
   ? (??) :  ?  :  -;   // ignore data changes when not clock edge
endtable

specify
   (posedge clk => (q +: d)) = (1);  // 1ns clock-to-q delay
endspecify

endprimitive