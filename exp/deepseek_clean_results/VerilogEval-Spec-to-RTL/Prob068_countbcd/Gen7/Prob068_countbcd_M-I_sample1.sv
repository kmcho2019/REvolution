module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digit_0, digit_1, digit_2, digit_3;
    reg carry_0, carry_1, carry_2;
    wire [3:0] next_digit_0, next_digit_1, next_digit_2, next_digit_3;
    
    // Output assignments
    assign q = {digit_3, digit_2, digit_1, digit_0};
    assign ena = {carry_2, carry_1, carry_0};
    
    // Next digit logic (combinational)
    assign next_digit_0 = (digit_0 == 4'd9) ? 4'd0 : digit_0 + 4'd1;
    assign next_digit_1 = (digit_1 == 4'd9) ? 4'd0 : digit_1 + 4'd1;
    assign next_digit_2 = (digit_2 == 4'd9) ? 4'd0 : digit_2 + 4'd1;
    assign next_digit_3 = (digit_3 == 4'd9) ? 4'd0 : digit_3 + 4'd1;
    
    // Registered carry generation
    always @(posedge clk) begin
        if (reset) begin
            carry_0 <= 1'b0;
            carry_1 <= 1'b0;
            carry_2 <= 1'b0;
        end else begin
            carry_0 <= (digit_0 == 4'd9);
            carry_1 <= (digit_1 == 4'd9) & carry_0;
            carry_2 <= (digit_2 == 4'd9) & carry_1;
        end
    end
    
    // Single always block for all digit counters with clock gating
    always @(posedge clk) begin
        if (reset) begin
            digit_0 <= 4'd0;
            digit_1 <= 4'd0;
            digit_2 <= 4'd0;
            digit_3 <= 4'd0;
        end else begin
            // Ones digit always increments
            digit_0 <= next_digit_0;
            
            // Tens digit increments only when carry_0 is set
            if (carry_0) digit_1 <= next_digit_1;
            
            // Hundreds digit increments only when carry_1 is set
            if (carry_1) digit_2 <= next_digit_2;
            
            // Thousands digit increments only when carry_2 is set
            if (carry_2) digit_3 <= next_digit_3;
        end
    end

endmodule