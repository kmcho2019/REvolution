module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // Shift register to track past values of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 3'b000; // Reset shift register to all zeros
        data_out <= 0; // Reset output to zero
    end else begin
        // Shift in the current value of data_in
        shift_reg <= {shift_reg[1:0], data_in};
        
        // Check for the pulse pattern (0-1-0) in the shift register
        if ((shift_reg == 3'b101) || (shift_reg == 3'b010 && data_in == 1'b0)) begin
            // If the pattern matches, set data_out to 1
            data_out <= 1;
        end else begin
            // Otherwise, set data_out to 0
            data_out <= 0;
        end
    end
end

endmodule