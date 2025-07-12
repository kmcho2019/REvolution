module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output wire [3:0] out // Current LFSR state
);

reg [3:0] state;

assign out = state;

always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0001;  // Non-zero initialization
    end
    else begin
        // Shift left and insert inverted feedback at LSB
        // Feedback = ~(state[3] ^ state[2])
        state <= {state[2:0], ~(state[3] ^ state[2])};
    end
end

endmodule