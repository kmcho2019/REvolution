module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digits [0:3];  // 4 digits (thousands, hundreds, tens, ones)
    wire [3:0] ones = digits[0];
    wire [3:0] tens = digits[1];
    wire [3:0] hundreds = digits[2];
    wire [3:0] thousands = digits[3];

    // Combinational enable logic
    assign ena[0] = (ones == 4'd9);          // ones rollover
    assign ena[1] = (tens == 4'd9) & ena[0];  // tens rollover
    assign ena[2] = (hundreds == 4'd9) & ena[1]; // hundreds rollover

    // Concatenate output
    assign q = {thousands, hundreds, tens, ones};

    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
        end else begin
            // Always increment ones digit
            digits[0] <= (digits[0] == 4'd9) ? 4'd0 : digits[0] + 4'd1;

            // Conditional increments for higher digits
            digits[1] <= (ena[0]) ? 
                ((digits[1] == 4'd9) ? 4'd0 : digits[1] + 4'd1) : 
                digits[1];
                
            digits[2] <= (ena[1]) ? 
                ((digits[2] == 4'd9) ? 4'd0 : digits[2] + 4'd1) : 
                digits[2];
                
            digits[3] <= (ena[2]) ? 
                ((digits[3] == 4'd9) ? 4'd0 : digits[3] + 4'd1) : 
                digits[3];
        end
    end

endmodule