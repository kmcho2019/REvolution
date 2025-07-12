module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Output Logic: Directly assign the output based on the current state
assign q = q_reg;

// Sequential Logic: Handle load and rotation within the same always block
always @(posedge clk) begin
    // Load data into the register if load is high
    if (load) begin
        q_reg <= data;
    end else begin
        // Determine the next state based on the enable signals
        case (ena)
            2'b01: // Rotate right
                q_reg <= {q_reg[0], q_reg[99:1]};
            2'b10: // Rotate left
                q_reg <= {q_reg[98:0], q_reg[99]};
            default: // No rotation
                q_reg <= q_reg;
        endcase
    end
end

endmodule