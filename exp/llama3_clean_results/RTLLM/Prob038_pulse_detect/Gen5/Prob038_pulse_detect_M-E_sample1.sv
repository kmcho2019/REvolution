module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // 3-bit shift register to store current and previous 2 cycles of data_in
reg [2:0] pulse_pattern; // The expected pulse pattern: 0-1-0

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 3'b000; // Reset shift register
        data_out <= 0; // Reset output
    end else begin
        // Shift in new data
        shift_reg <= {data_in, shift_reg[2:1]};
        
        // Check if the current shift register content matches the pulse pattern
        if (shift_reg == 3'b010) begin
            data_out <= 1; // Pulse detected, set output to 1
        end else begin
            data_out <= 0; // No pulse detected, set output to 0
        end
    end
end

endmodule