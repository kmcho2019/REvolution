module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Internal state register
reg [3:0] state;

// Calculate feedback based on the most significant and second most significant bits
wire feedback;
assign feedback = ~ (state[3] ^ state[2]); // Invert the result of XOR for feedback

// Continuous assignment for output
assign out = state;

// Sequential logic for updating the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize state to a non-zero value for pseudo-random sequence generation
        state <= 4'b1000; 
    end else begin
        // Shift left and insert inverted feedback at LSB
        state <= {state[2:0], feedback};
    end
end

endmodule