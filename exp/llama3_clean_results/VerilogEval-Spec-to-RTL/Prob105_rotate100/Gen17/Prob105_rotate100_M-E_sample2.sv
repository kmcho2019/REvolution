module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Barrel shifter for right rotation
wire [99:0] right_shift;
assign right_shift = {q_reg[0], q_reg[99:1]};

// Barrel shifter for left rotation
wire [99:0] left_shift;
assign left_shift = {q_reg[98:0], q_reg[99]};

// Multiplexer to select the correct output
always @(posedge clk) begin
    if (load) begin
        // Load the shift register with data
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: q_reg <= right_shift; // Rotate right
            2'b10: q_reg <= left_shift; // Rotate left
            default: q_reg <= q_reg; // No rotation
        endcase
    end
end

// Directly update the output q
assign q = q_reg;

endmodule