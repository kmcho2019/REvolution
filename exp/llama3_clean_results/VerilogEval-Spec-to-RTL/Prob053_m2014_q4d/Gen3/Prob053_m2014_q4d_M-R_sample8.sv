module TopModule(
    input clk,
    input in,
    output reg out
);

reg internal_state;

assign out = internal_state;

always @(posedge clk) begin
    internal_state <= in ^ internal_state;
end

endmodule