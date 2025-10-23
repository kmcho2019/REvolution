module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;
reg clk_gated; // Gated clock signal

// Generate gated clock signal
always @(posedge clk) begin
    clk_gated <= load || (ena!= 2'b00);
end

// Handle sequential logic with gated clock
always @(posedge clk_gated) begin
    if (load) begin
        // Load the shift register with data
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: q_reg <= {q_reg[0], q_reg[99:1]}; // Rotate right
            2'b10: q_reg <= {q_reg[98:0], q_reg[99]}; // Rotate left
            default: q_reg <= q_reg; // No rotation
        endcase
    end
end

// Directly update the output q
assign q = q_reg;

endmodule