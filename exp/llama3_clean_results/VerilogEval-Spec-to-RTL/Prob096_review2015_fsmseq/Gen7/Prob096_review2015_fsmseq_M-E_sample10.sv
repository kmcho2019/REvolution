module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_reg; // Shift register to hold the recent input bits
reg detected; // Flag to indicate if the sequence has been detected

always @(posedge clk) begin
    if(reset) begin
        shift_reg <= 4'b0000;
        detected <= 1'b0;
        start_shifting <= 1'b0;
    end else begin
        // Shift in the new data bit
        shift_reg <= {shift_reg[2:0], data};
        
        // Check if the sequence has been detected
        if(shift_reg == 4'b1101 && !detected) begin
            detected <= 1'b1;
            start_shifting <= 1'b1;
        end else if(detected) begin
            // Once detected, keep start_shifting high until reset
            start_shifting <= 1'b1;
        end else begin
            start_shifting <= 1'b0;
        end
    end
end

endmodule