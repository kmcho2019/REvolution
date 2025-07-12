module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (~a) state <= b;
end

always @(*) begin
    if (~a) q = b;
    else q = (state) ? ~b : b;
end

endmodule