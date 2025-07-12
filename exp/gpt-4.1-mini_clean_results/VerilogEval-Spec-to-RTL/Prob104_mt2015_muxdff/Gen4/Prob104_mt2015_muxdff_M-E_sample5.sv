module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

reg mux_out;

always @(*) begin
    if (L)
        mux_out = r_in;
    else
        mux_out = q_in;
end

always @(posedge clk) begin
    Q <= mux_out;
end

endmodule