module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // 3-bit shift register to track input signal history

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        shift_reg <= 3'b000; // Initialize shift register
        data_out <= 1'b0; // Initialize output
    end else begin
        // Shift in new input value and update shift register
        if (data_in != shift_reg[0]) begin // Only shift if input changes
            shift_reg <= {data_in, shift_reg[2:1]};
        end
        
        // Check for pulse pattern in shift register
        if (shift_reg == 3'b101) begin
            data_out <= 1'b1; // Pulse detected, set output to 1
        end else begin
            data_out <= 1'b0; // No pulse detected, set output to 0
        end
    end
end

endmodule