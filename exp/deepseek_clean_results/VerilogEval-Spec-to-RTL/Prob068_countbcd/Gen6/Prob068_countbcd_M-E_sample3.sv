module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Individual digit counters
    reg [3:0] digit_0;  // Ones
    reg [3:0] digit_1;  // Tens
    reg [3:0] digit_2;  // Hundreds
    reg [3:0] digit_3;  // Thousands
    
    // Carry signals between digits
    wire carry_0, carry_1, carry_2;
    
    // Assign output signals
    assign q = {digit_3, digit_2, digit_1, digit_0};
    assign ena = {carry_2, carry_1, carry_0};
    
    // Generate carry signals
    assign carry_0 = (digit_0 == 4'd9);
    assign carry_1 = (digit_1 == 4'd9) & carry_0;
    assign carry_2 = (digit_2 == 4'd9) & carry_1;
    
    // Ones digit counter (always increments)
    always @(posedge clk) begin
        if (reset) begin
            digit_0 <= 4'd0;
        end else begin
            digit_0 <= (digit_0 == 4'd9) ? 4'd0 : digit_0 + 4'd1;
        end
    end
    
    // Tens digit counter (increments on carry_0)
    always @(posedge clk) begin
        if (reset) begin
            digit_1 <= 4'd0;
        end else if (carry_0) begin
            digit_1 <= (digit_1 == 4'd9) ? 4'd0 : digit_1 + 4'd1;
        end
    end
    
    // Hundreds digit counter (increments on carry_1)
    always @(posedge clk) begin
        if (reset) begin
            digit_2 <= 4'd0;
        end else if (carry_1) begin
            digit_2 <= (digit_2 == 4'd9) ? 4'd0 : digit_2 + 4'd1;
        end
    end
    
    // Thousands digit counter (increments on carry_2)
    always @(posedge clk) begin
        if (reset) begin
            digit_3 <= 4'd0;
        end else if (carry_2) begin
            digit_3 <= (digit_3 == 4'd9) ? 4'd0 : digit_3 + 4'd1;
        end
    end

endmodule