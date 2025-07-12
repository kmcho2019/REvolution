module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [99:0] shift_reg;  // Shift register to store the sequence

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset the shift register
        shift_reg <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Shift the sequence in the shift register
        shift_reg <= {shift_reg[98:0], 1'b0};
        
        // Generate CLK_50
        if(shift_reg[0] == 1'b1) begin
            CLK_50 <= ~CLK_50;
        end
        
        // Generate CLK_10
        if(shift_reg[9] == 1'b1) begin
            CLK_10 <= ~CLK_10;
        end
        
        // Generate CLK_1
        if(shift_reg[99] == 1'b1) begin
            CLK_1 <= ~CLK_1;
        end
    end
end

endmodule