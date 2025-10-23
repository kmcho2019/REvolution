module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // 3-bit shift register to store current and two previous cycles of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 3'b000; // Reset shift register
        data_out <= 0; // Reset output
    end else begin
        // Shift in new data
        shift_reg <= {data_in, shift_reg[2:1]};
        
        // Check if the current input is 0, the previous input is 1, and the input two cycles ago is 0
        if (data_in == 0 && shift_reg[2] == 1 && shift_reg[1] == 0) begin
            data_out <= 1; // Pulse detected, set output to 1
        end else begin
            data_out <= 0; // No pulse detected, set output to 0
        end
    end
end

endmodule