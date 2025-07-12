module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;
    
    wire ones_ena = 1'b1;  // Always enabled
    wire tens_ena;
    wire hundreds_ena;
    wire thousands_ena;
    
    assign q = {thousands, hundreds, tens, ones};
    assign ena = {thousands_ena, hundreds_ena, tens_ena};
    
    // Ones digit counter (always enabled)
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
        end else if (ones_ena) begin
            ones <= (ones == 4'd9) ? 4'd0 : ones + 1;
        end
    end
    
    assign tens_ena = (ones == 4'd9) & ones_ena;
    
    // Tens digit counter
    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'd0;
        end else if (tens_ena) begin
            tens <= (tens == 4'd9) ? 4'd0 : tens + 1;
        end
    end
    
    assign hundreds_ena = (tens == 4'd9) & tens_ena;
    
    // Hundreds digit counter
    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
        end else if (hundreds_ena) begin
            hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 1;
        end
    end
    
    assign thousands_ena = (hundreds == 4'd9) & hundreds_ena;
    
    // Thousands digit counter
    always @(posedge clk) begin
        if (reset) begin
            thousands <= 4'd0;
        end else if (thousands_ena) begin
            thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 1;
        end
    end

endmodule