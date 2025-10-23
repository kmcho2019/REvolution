module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    
    // Extract individual digits
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];
    
    assign q = counter;
    
    // Enable signals (assert when digit is 9 and all lower digits are 9)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9) & ena[0];
    assign ena[2] = (hundreds == 4'd9) & ena[1];
    
    // Increment logic with overflow handling
    wire [15:0] next_counter = reset ? 16'd0 : 
        (ones != 4'd9) ? counter + 16'd1 :         // Normal increment
        (tens != 4'd9) ? counter + 16'd7 :         // ones overflow (add 16'd7 = 16'd10-16'd3)
        (hundreds != 4'd9) ? counter + 16'd103 :   // tens overflow (add 16'd103 = 16'd100-16'd93)
        (thousands != 4'd9) ? counter + 16'd1003 : // hundreds overflow (add 16'd1003 = 16'd1000-16'd993)
        counter + 16'd1;                           // full rollover (though spec doesn't require it)
    
    always @(posedge clk) begin
        counter <= next_counter;
    end

endmodule