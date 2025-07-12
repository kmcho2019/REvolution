module right_shifter (
    input wire clk,       // Clock input
    input wire d,         // Data input
    output wire [7:0] q   // Shift register output
);

reg [7:0] q_reg = 8'b0;  // Initialize register to zero

// Combinational shift operation
wire [7:0] next_q = {d, q_reg[7:1]};

// Sequential storage
always @(posedge clk) begin
    q_reg <= next_q;
end

// Output assignment
assign q = q_reg;

endmodule