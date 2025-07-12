module LFSR #(
    parameter LENGTH = 4
) (
    input clk,
    input rst,
    output reg [LENGTH-1:0] out
);

reg [LENGTH-1:0] state;

// Sequential logic for updating the LFSR state
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        state <= {LENGTH{1'b0}}; // Initialize state to zero on reset
    end else begin
        // Calculate feedback as XOR of MSB and second MSB, and shift left
        state <= {state[LENGTH-2:0], state[LENGTH-1] ^ state[LENGTH-2]};
    end
end

// Continuous assignment for output
assign out = state;

endmodule