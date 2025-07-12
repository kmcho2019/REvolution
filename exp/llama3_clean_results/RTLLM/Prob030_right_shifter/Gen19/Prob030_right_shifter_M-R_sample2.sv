module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;  // Internal register
assign q = q_reg;  // Assign internal register to output

initial q_reg = 8'd0;  // Initialize internal register to 0

wire [7:0] q_next;  // Next state of q register
assign q_next = {d, q_reg[7:1]};  // Calculate next state

always @(posedge clk) begin
    q_reg <= q_next;  // Update internal register at rising edge of clock
end

endmodule