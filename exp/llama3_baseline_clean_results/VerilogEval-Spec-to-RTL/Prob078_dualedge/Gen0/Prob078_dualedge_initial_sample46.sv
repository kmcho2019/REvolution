module TopModule(
    input clk,
    input d,
    output q
    );

reg q_int;
reg q_int2;
assign q = (clk) ? q_int : q_int2;

always @(posedge clk)
    q_int <= d;

always @(negedge clk)
    q_int2 <= d;

endmodule