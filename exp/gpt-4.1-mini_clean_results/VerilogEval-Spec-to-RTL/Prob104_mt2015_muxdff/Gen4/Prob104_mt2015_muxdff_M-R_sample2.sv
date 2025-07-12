module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

reg d;

always @(*) begin
    if (L)
        d = r_in;
    else
        d = q_in;
end

always @(posedge clk) begin
    Q <= d;
end

endmodule