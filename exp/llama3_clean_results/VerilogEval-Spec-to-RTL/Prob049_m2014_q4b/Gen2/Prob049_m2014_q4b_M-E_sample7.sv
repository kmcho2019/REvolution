module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg internal_q;

assign internal_q = (ar) ? 1'b0 : (clk) ? d : internal_q;

always @(posedge clk or posedge ar)
    q <= internal_q;

endmodule