module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Handle sequential logic in a single always block
always @(posedge clk) begin
    if (load) begin
        // Load the shift register with data
        q_reg <= data;
    end else if (ena == 2'b01) begin
        // Rotate right
        q_reg <= {q_reg[0], q_reg[99:1]};
    end else if (ena == 2'b10) begin
        // Rotate left
        q_reg <= {q_reg[98:0], q_reg[99]};
    end
end

// Directly update the output q
assign q = q_reg;

endmodule