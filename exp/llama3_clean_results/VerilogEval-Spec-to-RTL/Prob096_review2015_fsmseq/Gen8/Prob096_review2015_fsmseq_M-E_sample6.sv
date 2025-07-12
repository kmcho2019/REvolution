module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] shift_reg; // 4-bit shift register

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000; // Reset shift register
        start_shifting <= 0;
    end else begin
        shift_reg <= {shift_reg[2:0], data}; // Shift register and append new bit
        if (shift_reg == 4'b1101) begin // Check if sequence matches
            start_shifting <= 1;
        end else if (start_shifting) begin
            start_shifting <= 1; // Keep start_shifting at 1 if already set
        end else begin
            start_shifting <= 0; // Reset start_shifting if sequence doesn't match
        end
    end
end

endmodule