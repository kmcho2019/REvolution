module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] shift_reg; // 4-bit shift register

// Shift register and sequence detection logic
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000; // Reset shift register
        start_shifting <= 0; // Reset start_shifting
    end else begin
        shift_reg <= {shift_reg[2:0], data}; // Shift input data into register
        if (shift_reg == 4'b1101 &&!start_shifting) begin
            start_shifting <= 1; // Set start_shifting if sequence matches and start_shifting is not already set
        end
    end
end

endmodule