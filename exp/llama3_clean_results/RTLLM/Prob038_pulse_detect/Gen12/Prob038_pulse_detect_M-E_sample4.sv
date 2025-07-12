module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // 3-bit shift register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        shift_reg <= 3'b000; // Initialize shift register
        data_out <= 1'b0;
    end else begin
        shift_reg <= {data_in, shift_reg[2:1]}; // Shift data_in into shift register
        
        // Compare shift register contents with pulse pattern (0, 1, 0)
        if (shift_reg == 3'b010) begin
            data_out <= 1'b1; // Set data_out to 1 if pulse pattern is detected
        end else begin
            data_out <= 1'b0;
        end
    end
end

endmodule