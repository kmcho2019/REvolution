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
            start_shifting <= 1; // Set start_shifting to 1 if sequence is found
        end
    end
end

endmodule