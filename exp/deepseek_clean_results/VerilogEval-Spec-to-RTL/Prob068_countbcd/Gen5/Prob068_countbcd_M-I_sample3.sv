module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] digits;
    reg ena2_reg;
    
    // Digit assignments
    wire [3:0] ones = digits[3:0];
    wire [3:0] tens = digits[7:4];
    wire [3:0] hundreds = digits[11:8];
    wire [3:0] thousands = digits[15:12];
    
    assign q = digits;
    
    // Rollover conditions
    wire ones_roll = (ones == 4'd9);
    wire tens_roll = (tens == 4'd9);
    wire hundreds_roll = (hundreds == 4'd9);
    
    // Parallel enable generation
    assign ena[0] = ones_roll;
    assign ena[1] = ones_roll & tens_roll;
    assign ena[2] = ena2_reg;  // Pipelined version
    
    always @(posedge clk) begin
        if (reset) begin
            digits <= 16'd0;
            ena2_reg <= 1'b0;
        end
        else begin
            // Pipeline stage for ena[2]
            ena2_reg <= ones_roll & tens_roll & hundreds_roll;
            
            // Update ones digit (always increments)
            digits[3:0] <= ones_roll ? 4'd0 : ones + 4'd1;
            
            // Update tens digit (when enabled)
            if (ena[0]) begin
                digits[7:4] <= tens_roll ? 4'd0 : tens + 4'd1;
            end
            
            // Update hundreds digit (when enabled)
            if (ena[1]) begin
                digits[11:8] <= hundreds_roll ? 4'd0 : hundreds + 4'd1;
            end
            
            // Update thousands digit (when enabled)
            if (ena2_reg) begin
                digits[15:12] <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
            end
        end
    end

endmodule