module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;

always @(posedge clk) begin
    q_reg <= {d, q_reg[7:1]};
    q <= q_reg;
end

initial q = 8'd0;  // Initialize q to 0
initial q_reg = 8'd0;  // Initialize q_reg to 0

endmodule