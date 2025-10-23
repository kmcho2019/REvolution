module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

// Using a reg declaration for the output to potentially allow for
// more synthesis optimization opportunities
reg [99:0] q_reg;

// The logic within the always block remains largely the same, as it's
// already straightforward and efficiently implements the desired functionality.
always @(posedge clk) begin
    if (load) begin
        // Direct assignment when load is high, minimizing unnecessary logic.
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: q_reg <= {q_reg[0], q_reg[99:1]};
            2'b10: q_reg <= {q_reg[98:0], q_reg[99]};
            default: q_reg <= q_reg;
        endcase
    end
end

// Assign the output directly from the register to minimize additional logic.
assign q = q_reg;

endmodule