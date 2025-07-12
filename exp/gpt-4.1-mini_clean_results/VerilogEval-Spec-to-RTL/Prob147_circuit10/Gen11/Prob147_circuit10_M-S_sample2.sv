module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

always @(posedge clk) begin
    state <= a ^ b;
end

assign q = state;

initial begin
    state = 1'b0;
end

endmodule