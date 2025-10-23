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
    
    wire [3:0] next_0, next_1, next_2, next_3;
    wire carry_0, carry_1, carry_2;
    
    // BCD increment with carry out
    assign {carry_0, next_0} = (digit_0 == 4'd9) ? {1'b1, 4'd0} : {1'b0, digit_0 + 1'b1};
    assign {carry_1, next_1} = (digit_1 == 4'd9) ? {1'b1, 4'd0} : {1'b0, digit_1 + 1'b1};
    assign {carry_2, next_2} = (digit_2 == 4'd9) ? {1'b1, 4'd0} : {1'b0, digit_2 + 1'b1};
    assign next_3 = (digit_3 == 4'd9) ? 4'd0 : digit_3 + 1'b1;
    
    // Enable signals (carry out from each digit)
    assign ena = {carry_2, carry_1, carry_0};
    
    // Output concatenation
    assign q = {digit_3, digit_2, digit_1, digit_0};
    
    always @(posedge clk) begin
        if (reset) begin
            digit_0 <= 4'd0;
            digit_1 <= 4'd0;
            digit_2 <= 4'd0;
            digit_3 <= 4'd0;
        end else begin
            digit_0 <= next_0;
            digit_1 <= carry_0 ? next_1 : digit_1;
            digit_2 <= (carry_0 & carry_1) ? next_2 : digit_2;
            digit_3 <= (carry_0 & carry_1 & carry_2) ? next_3 : digit_3;
        end
    end

endmodule