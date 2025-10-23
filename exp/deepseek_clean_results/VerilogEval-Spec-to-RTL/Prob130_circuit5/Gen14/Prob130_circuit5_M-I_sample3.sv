module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Decode c values 0-3
wire [3:0] sel;
assign sel[0] = (c == 4'd0);  // c == 0
assign sel[1] = (c == 4'd1);  // c == 1
assign sel[2] = (c == 4'd2);  // c == 2
assign sel[3] = (c == 4'd3);  // c == 3

// 4:1 multiplexer with default case
assign q = (sel[0]) ? b :
           (sel[1]) ? e :
           (sel[2]) ? a :
           (sel[3]) ? d :
           4'b1111;  // Default case (f)

endmodule