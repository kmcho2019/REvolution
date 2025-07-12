module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Decode the selection signal
wire sel0 = (c == 4'd0);
wire sel1 = (c == 4'd1);
wire sel2 = (c == 4'd2);
wire sel3 = (c == 4'd3);
wire sel_default = ~(sel0 | sel1 | sel2 | sel3);  // c > 3

// Implement as a single 5:1 mux with priority encoding
assign q = sel0 ? b :
           sel1 ? e :
           sel2 ? a :
           sel3 ? d :
           4'b1111;  // Default case (all 1s)

endmodule