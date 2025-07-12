module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

// Internal register to hold the current state of the rotator
reg [99:0] q_reg;

// Assign the output q directly from the internal register
assign q = q_reg;

// Handle sequential logic in a single always block
always @(posedge clk) begin
    if (load) begin
        // Load the shift register with data when load is high
        q_reg <= data;
    end else begin
        // Rotate the register based on the ena signal
        case (ena)
            2'b01: q_reg <= {q_reg[0], q_reg[99:1]}; // Rotate right by one bit
            2'b10: q_reg <= {q_reg[98:0], q_reg[99]}; // Rotate left by one bit
            default: q_reg <= q_reg; // No rotation for ena = 2'b00 or 2'b11
        endcase
    end
end

endmodule