module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // 3-bit shift register to store last three values of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        shift_reg <= 0;
        data_out <= 0;
    end else begin
        shift_reg <= {data_in, shift_reg[2:1]}; // Shift values and load new data_in
        if (shift_reg == 3'b101) begin // Check for pulse pattern
            data_out <= 1; // Set output to 1 if pulse detected
        end else begin
            data_out <= 0; // Set output to 0 otherwise
        end
    end
end

endmodule