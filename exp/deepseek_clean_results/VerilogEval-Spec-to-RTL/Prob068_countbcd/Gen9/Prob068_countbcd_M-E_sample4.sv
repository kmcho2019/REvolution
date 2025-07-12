module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digit0;  // ones
    reg [3:0] digit1;  // tens
    reg [3:0] digit2;  // hundreds
    reg [3:0] digit3;  // thousands
    
    wire carry0, carry1, carry2;
    
    // Digit 0 (ones) - always increments
    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0;
        end else begin
            if (digit0 == 4'd9) begin
                digit0 <= 4'd0;
            end else begin
                digit0 <= digit0 + 4'd1;
            end
        end
    end
    assign carry0 = (digit0 == 4'd9);
    
    // Digit 1 (tens) - increments when ones rolls over
    always @(posedge clk) begin
        if (reset) begin
            digit1 <= 4'd0;
        end else if (carry0) begin
            if (digit1 == 4'd9) begin
                digit1 <= 4'd0;
            end else begin
                digit1 <= digit1 + 4'd1;
            end
        end
    end
    assign carry1 = (digit1 == 4'd9) & carry0;
    
    // Digit 2 (hundreds) - increments when tens rolls over
    always @(posedge clk) begin
        if (reset) begin
            digit2 <= 4'd0;
        end else if (carry1) begin
            if (digit2 == 4'd9) begin
                digit2 <= 4'd0;
            end else begin
                digit2 <= digit2 + 4'd1;
            end
        end
    end
    assign carry2 = (digit2 == 4'd9) & carry1;
    
    // Digit 3 (thousands) - increments when hundreds rolls over
    always @(posedge clk) begin
        if (reset) begin
            digit3 <= 4'd0;
        end else if (carry2) begin
            if (digit3 == 4'd9) begin
                digit3 <= 4'd0;
            end else begin
                digit3 <= digit3 + 4'd1;
            end
        end
    end
    
    // Output assignments
    assign q = {digit3, digit2, digit1, digit0};
    assign ena = {carry2, carry1, carry0};

endmodule