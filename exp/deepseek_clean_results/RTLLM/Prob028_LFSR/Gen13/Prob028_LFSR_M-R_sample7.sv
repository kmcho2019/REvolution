module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output wire [3:0] out  // Current LFSR state
);

// State register
reg [3:0] state;

// Feedback calculation using continuous assignment
wire feedback = ~(state[3] ^ state[2]);  // Note: Inverted as per original spec

// Output assignment
assign out = state;

always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0001;  // Non-zero initialization
    end
    else begin
        // Shift left and insert inverted feedback at LSB
        state <= {state[2:0], feedback};
    end
end

endmodule