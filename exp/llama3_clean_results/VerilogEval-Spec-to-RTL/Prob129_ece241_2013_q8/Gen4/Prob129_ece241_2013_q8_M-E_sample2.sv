module TopModule(
    input        clk,
    input        aresetn,
    input        x,
    output reg   z
);

reg [2:0] shift_reg; // 3-bit shift register

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        shift_reg <= 3'b000; // Reset shift register
        z <= 1'b0; // Reset output
    end else begin
        shift_reg <= {shift_reg[1:0], x}; // Shift in new bit
        z <= (shift_reg == 3'b101); // Set output if sequence is recognized
    end
end

endmodule