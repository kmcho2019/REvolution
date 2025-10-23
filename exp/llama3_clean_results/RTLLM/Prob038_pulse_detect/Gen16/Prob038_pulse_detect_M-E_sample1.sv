module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // 3-bit shift register to store the current and previous values of data_in

// Sequential logic for the shift register and comparator
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        shift_reg <= 3'b000;
        data_out <= 1'b0;
    end else begin
        shift_reg <= {data_in, shift_reg[2:1]}; // Shift the current value of data_in into the most significant bit of the register
        if (shift_reg == 3'b010) begin // Compare the values in the register to detect the pulse pattern
            data_out <= 1'b1;
        end else begin
            data_out <= 1'b0;
        end
    end
end

endmodule