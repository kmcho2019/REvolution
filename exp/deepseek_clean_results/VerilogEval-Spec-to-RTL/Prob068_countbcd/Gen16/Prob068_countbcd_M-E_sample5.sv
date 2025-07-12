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
    
    wire ena_0, ena_1, ena_2;
    
    assign q = {digit_3, digit_2, digit_1, digit_0};
    assign ena = {ena_2, ena_1, ena_0};
    
    // Carry lookahead enable logic
    assign ena_0 = (digit_0 == 4'd9);
    assign ena_1 = (digit_1 == 4'd9) & ena_0;
    assign ena_2 = (digit_2 == 4'd9) & ena_1;
    
    always @(posedge clk) begin
        if (reset) begin
            digit_0 <= 4'd0;
            digit_1 <= 4'd0;
            digit_2 <= 4'd0;
            digit_3 <= 4'd0;
        end
        else begin
            // Digit 0 (ones) always increments
            digit_0 <= (digit_0 == 4'd9) ? 4'd0 : digit_0 + 1;
            
            // Digit 1 (tens) increments when digit_0 rolls over
            if (ena_0) begin
                digit_1 <= (digit_1 == 4'd9) ? 4'd0 : digit_1 + 1;
            end
            
            // Digit 2 (hundreds) increments when digit_1 rolls over
            if (ena_1) begin
                digit_2 <= (digit_2 == 4'd9) ? 4'd0 : digit_2 + 1;
            end
            
            // Digit 3 (thousands) increments when digit_2 rolls over
            if (ena_2) begin
                digit_3 <= (digit_3 == 4'd9) ? 4'd0 : digit_3 + 1;
            end
        end
    end

endmodule