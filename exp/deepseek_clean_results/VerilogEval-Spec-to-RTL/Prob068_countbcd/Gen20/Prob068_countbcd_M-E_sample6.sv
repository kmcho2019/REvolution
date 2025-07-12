module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [3:0] prev_ones, prev_tens, prev_hundreds;
    wire [3:0] ones, tens, hundreds, thousands;
    
    // Single binary counter
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            prev_ones <= 4'd0;
            prev_tens <= 4'd0;
            prev_hundreds <= 4'd0;
        end else begin
            counter <= (counter == 16'd9999) ? 16'd0 : counter + 16'd1;
            
            // Store previous digit values for edge detection
            prev_ones <= ones;
            prev_tens <= tens;
            prev_hundreds <= hundreds;
        end
    end
    
    // BCD digit extraction
    assign ones = counter % 10;
    assign tens = (counter / 10) % 10;
    assign hundreds = (counter / 100) % 10;
    assign thousands = counter / 1000;
    
    // Enable generation (pulse when digit rolls over)
    assign ena[0] = (ones == 4'd9) && (prev_ones != 4'd9);  // tens enable
    assign ena[1] = (tens == 4'd9) && (prev_tens != 4'd9) && (ones == 4'd9);  // hundreds enable
    assign ena[2] = (hundreds == 4'd9) && (prev_hundreds != 4'd9) && (tens == 4'd9) && (ones == 4'd9);  // thousands enable
    
    // Output concatenation
    assign q = {thousands, hundreds, tens, ones};

endmodule