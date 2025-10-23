module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // 3-bit shift register to track recent history of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        shift_reg <= 3'b000; // Initialize shift register
        data_out <= 0;
    end else begin
        shift_reg <= {data_in, shift_reg[2:1]}; // Update shift register
        if (shift_reg == 3'b010) begin // Check for pulse pattern
            data_out <= 1; // Assert data_out if pulse detected
        end else begin
            data_out <= 0;
        end
    end
end

endmodule