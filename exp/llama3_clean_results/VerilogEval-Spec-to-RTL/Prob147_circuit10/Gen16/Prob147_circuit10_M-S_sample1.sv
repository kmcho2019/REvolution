module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (~a) state <= b;
    else state <= state;
end

always @(*) begin
    if (~a) q = b;
    else q = ~state;
end

endmodule