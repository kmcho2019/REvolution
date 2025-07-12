module LFSR (
    input wire clk,            // Clock
    input wire rst,            // Active-high synchronous reset
    output wire [3:0] out      // Current LFSR state
);

reg [3:0] current_state;
wire feedback;

// Feedback is XOR of bits 3 and 2, then inverted
assign feedback = ~(current_state[3] ^ current_state[2]);

// Current state register
always @(posedge clk) begin
    if (rst) begin
        current_state <= 4'b0000;  // Initialize to zero on reset
    end
    else begin
        // Shift left and insert inverted feedback at LSB
        current_state <= {current_state[2:0], feedback};
    end
end

assign out = current_state;

endmodule