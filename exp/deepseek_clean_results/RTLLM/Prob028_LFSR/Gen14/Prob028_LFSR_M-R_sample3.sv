module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // Registered output
);

// Internal signals
wire feedback;
reg [3:0] state;

// Feedback calculation (XOR bits 3 and 2, then invert)
assign feedback = ~(state[3] ^ state[2]);

// State register (sequential)
always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0001;  // Initialize to non-zero state
    end
    else begin
        state <= {state[2:0], feedback};  // Shift left and insert feedback
    end
end

// Output assignment (registered)
always @(posedge clk) begin
    out <= state;
end

endmodule