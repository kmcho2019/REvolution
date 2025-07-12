module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Digit outputs
    assign q = {thousands, hundreds, tens, ones};
    
    // Enable logic - parallel computation
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (ones == 4'd9) && (tens == 4'd9);
    assign ena[2] = (ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9);
    
    // Ones digit (always enabled)
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
        end else begin
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
        end
    end
    
    // Tens digit (enabled by ones overflow)
    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'd0;
        end else if (ena[0]) begin
            tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
        end
    end
    
    // Hundreds digit (enabled by tens overflow)
    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
        end else if (ena[1]) begin
            hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
        end
    end
    
    // Thousands digit (enabled by hundreds overflow)
    always @(posedge clk) begin
        if (reset) begin
            thousands <= 4'd0;
        end else if (ena[2]) begin
            thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
        end
    end

endmodule