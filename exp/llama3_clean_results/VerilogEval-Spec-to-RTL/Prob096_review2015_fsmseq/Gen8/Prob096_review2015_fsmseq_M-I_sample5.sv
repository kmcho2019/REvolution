module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] shift_reg; // 4-bit shift register
reg sequence_found; // State variable to track sequence detection

// Shift register and sequence detection logic
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000; // Reset shift register
        sequence_found <= 0; // Reset sequence_found state
        start_shifting <= 0; // Reset start_shifting
    end else begin
        shift_reg <= {shift_reg[2:0], data}; // Shift input data into register
        if (shift_reg == 4'b1101) begin // Check if sequence matches
            sequence_found <= 1; // Set sequence_found state if match found
        end
        start_shifting <= sequence_found; // Derive start_shifting from sequence_found
    end
end

endmodule