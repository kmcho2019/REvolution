module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_reg; // 4-bit shift register
reg detected; // Flag to indicate sequence detection

always @(posedge clk) begin
    if(reset) begin
        shift_reg <= 4'b0000;
        detected <= 1'b0;
        start_shifting <= 1'b0;
    end else begin
        // Shift the input data into the shift register
        shift_reg <= {shift_reg[2:0], data};
        
        // Check if the sequence 1101 is detected
        if(shift_reg == 4'b1101) begin
            detected <= 1'b1;
        end
        
        // If reset is asserted, clear the detected flag
        if(reset) begin
            detected <= 1'b0;
        end
        
        // Set start_shifting high if sequence is detected
        if(detected) begin
            start_shifting <= 1'b1;
        end else begin
            start_shifting <= 1'b0;
        end
    end
end

endmodule