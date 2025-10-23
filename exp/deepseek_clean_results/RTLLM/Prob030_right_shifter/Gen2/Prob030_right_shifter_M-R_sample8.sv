module right_shifter (
    input wire clk,       // Clock input
    input wire d,         // Data input
    output wire [7:0] q   // Shift register output
);

reg [7:0] q_reg = 8'b0;   // Initialize register to zero
wire [7:0] q_next;        // Next state value

// Combinational shift operation
assign q_next = {d, q_reg[7:1]};

// Clocked register update
always @(posedge clk) begin
    q_reg <= q_next;
end

// Continuous output assignment
assign q = q_reg;

endmodule