module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // 3-bit shift register to store input signal history

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        shift_reg <= 3'b000; // Initialize shift register
        data_out <= 0;
    end else begin
        // Shift the input signal into the shift register
        shift_reg <= {data_in, shift_reg[2:1]};
        
        // Check if the shift register contents match the desired pulse pattern
        if (shift_reg == 3'b101) begin
            data_out <= 1; // Assert output signal
        end else begin
            data_out <= 0; // Deassert output signal
        end
    end
end

endmodule