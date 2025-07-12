module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // 3-bit shift register to track input signal history

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b000; // Initialize shift register to zero
        data_out <= 0;
    end else begin
        shift_reg <= {data_in, shift_reg[2:1]}; // Shift in new data and discard oldest bit
        if (shift_reg == 3'b010) begin
            data_out <= 1; // Pulse detected, set output to 1
        end else begin
            data_out <= 0; // No pulse detected, set output to 0
        end
    end
end

endmodule