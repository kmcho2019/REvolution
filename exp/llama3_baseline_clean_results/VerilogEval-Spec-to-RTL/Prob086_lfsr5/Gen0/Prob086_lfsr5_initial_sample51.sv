module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 5'b10000; // Reset state to 1
    end else begin
        state <= {state[3:0], state[4] ^ state[2]}; // Shift right and XOR taps
    end
end

assign q = state;

endmodule