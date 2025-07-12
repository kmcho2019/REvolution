module TopModule (
    input  clk,
    input  d,
    output q
);

reg q_int;  // internal signal
reg q_out;  // final output

always @(posedge clk)
    q_int <= d;

always @(negedge clk)
    q_out <= q_int;

assign q = q_out;

endmodule