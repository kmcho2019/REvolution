module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

reg [3:0] state;

// Calculate feedback based on the most significant and second most significant bits
wire feedback;
assign feedback = state[3] ^ state[2];

// Sequential logic for updating the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 4'b0; // Initialize state to zero on reset
    end else begin
        // Shift left and insert feedback at LSB
        state <= {state[2:0], feedback};
    end
end

// Continuous assignment for output
assign out = state;

endmodule