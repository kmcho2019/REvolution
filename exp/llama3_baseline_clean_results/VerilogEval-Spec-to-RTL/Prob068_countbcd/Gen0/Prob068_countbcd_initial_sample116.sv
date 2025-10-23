module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones;  // ones digit counter
reg [3:0] tens;  // tens digit counter
reg [3:0] hundreds;  // hundreds digit counter
reg [3:0] thousands;  // thousands digit counter

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        // Increment ones digit counter
        ones <= ones + 1'd1;
        
        // Check for overflow of ones digit counter and increment tens digit counter
        if (ones == 4'd10) begin
            ones <= 4'd0;
            tens <= tens + 1'd1;
        end
        
        // Check for overflow of tens digit counter and increment hundreds digit counter
        if (tens == 4'd10) begin
            tens <= 4'd0;
            hundreds <= hundreds + 1'd1;
        end
        
        // Check for overflow of hundreds digit counter and increment thousands digit counter
        if (hundreds == 4'd10) begin
            hundreds <= 4'd0;
            thousands <= thousands + 1'd1;
        end
        
        // Check for overflow of thousands digit counter and wrap around
        if (thousands == 4'd10) begin
            thousands <= 4'd0;
        end
    end
end

// Assign output signals
assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

// Assign enable signals
assign ena[0] = (ones == 4'd9);  // Enable tens digit counter when ones digit counter is 9
assign ena[1] = (tens == 4'd9) && (ones == 4'd9);  // Enable hundreds digit counter when tens and ones digit counters are 9
assign ena[2] = (hundreds == 4'd9) && (tens == 4'd9) && (ones == 4'd9);  // Enable thousands digit counter when hundreds, tens, and ones digit counters are 9

endmodule