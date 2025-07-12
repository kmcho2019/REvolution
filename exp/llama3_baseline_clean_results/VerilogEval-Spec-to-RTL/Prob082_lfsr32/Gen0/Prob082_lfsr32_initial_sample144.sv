module TopModule(
    input clk,
    input reset,
    output [31:0] q
);

reg [31:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 32'h1;
    end else begin
        state[31:1] <= state[30:0]; // Shift right
        state[0] <= state[0] ^ state[22] ^ state[2] ^ state[1]; // Tap positions
    end
end

assign q = state;

endmodule