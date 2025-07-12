module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digit_0;  // ones
    reg [3:0] digit_1;  // tens
    reg [3:0] digit_2;  // hundreds
    reg [3:0] digit_3;  // thousands
    
    wire [3:0] next_digit_0;
    wire [3:0] next_digit_1;
    wire [3:0] next_digit_2;
    wire [3:0] next_digit_3;
    
    // Current counter value
    assign q = {digit_3, digit_2, digit_1, digit_0};
    
    // Enable signals (carry lookahead)
    assign ena[0] = (digit_0 == 4'd9);                     // tens enable
    assign ena[1] = (digit_0 == 4'd9) & (digit_1 == 4'd9); // hundreds enable
    assign ena[2] = (digit_0 == 4'd9) & (digit_1 == 4'd9) & (digit_2 == 4'd9); // thousands enable
    
    // Next digit values
    assign next_digit_0 = (digit_0 == 4'd9) ? 4'd0 : (digit_0 + 1);
    assign next_digit_1 = (ena[0] && digit_1 == 4'd9) ? 4'd0 : 
                         (ena[0] ? (digit_1 + 1) : digit_1);
    assign next_digit_2 = (ena[1] && digit_2 == 4'd9) ? 4'd0 : 
                         (ena[1] ? (digit_2 + 1) : digit_2);
    assign next_digit_3 = (ena[2] && digit_3 == 4'd9) ? 4'd0 : 
                         (ena[2] ? (digit_3 + 1) : digit_3);
    
    always @(posedge clk) begin
        if (reset) begin
            digit_0 <= 4'd0;
            digit_1 <= 4'd0;
            digit_2 <= 4'd0;
            digit_3 <= 4'd0;
        end else begin
            digit_0 <= next_digit_0;
            digit_1 <= next_digit_1;
            digit_2 <= next_digit_2;
            digit_3 <= next_digit_3;
        end
    end

endmodule