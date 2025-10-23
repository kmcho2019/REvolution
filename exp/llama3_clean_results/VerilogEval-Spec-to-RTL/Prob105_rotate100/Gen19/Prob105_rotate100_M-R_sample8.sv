module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;
wire [99:0] rotate_right = {q_reg[0], q_reg[99:1]};
wire [99:0] rotate_left = {q_reg[98:0], q_reg[99]};

// Handle sequential logic in a single always block
always @(posedge clk) begin
    if (load) begin
        // Load the shift register with data
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: q_reg <= rotate_right; // Rotate right
            2'b10: q_reg <= rotate_left; // Rotate left
            default: q_reg <= q_reg; // No rotation
        endcase
    end
end

// Directly update the output q
assign q = q_reg;

endmodule