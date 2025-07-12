module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state = 5'b00001; // Initialize state with a known value
assign q = state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 5'b00001; // Reset state to 1 (LSB) when reset is high
    end else begin
        state <= {state[2] ^ state[0], state[4:1]}; // Corrected LFSR next state calculation
    end
end

endmodule