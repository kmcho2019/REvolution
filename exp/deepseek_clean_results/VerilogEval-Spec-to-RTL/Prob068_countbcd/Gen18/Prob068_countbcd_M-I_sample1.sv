module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg ones_en, tens_en, hundreds_en;
    reg [1:0] ena_pipeline;
    
    // Clock gating control
    wire counting_en = ~reset & ~(&q);  // Disable when reset or at max count (9999)
    
    // Digit values
    assign q = {thousands, hundreds, tens, ones};
    
    // Enable logic with pipelining
    always @(posedge clk) begin
        if (reset) begin
            ena_pipeline <= 2'b00;
        end else begin
            ena_pipeline[0] <= (ones == 4'd9);
            ena_pipeline[1] <= (tens == 4'd9) & ena_pipeline[0];
        end
    end
    
    // Final enable signals
    assign ena[0] = ena_pipeline[0];
    assign ena[1] = ena_pipeline[1];
    assign ena[2] = (hundreds == 4'd9) & ena_pipeline[1];
    
    // Ones digit (with clock gating)
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
        end else if (counting_en) begin
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
        end
    end
    
    // Tens digit
    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'd0;
        end else if (ena[0]) begin
            tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
        end
    end
    
    // Hundreds digit
    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
        end else if (ena[1]) begin
            hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
        end
    end
    
    // Thousands digit
    always @(posedge clk) begin
        if (reset) begin
            thousands <= 4'd0;
        end else if (ena[2]) begin
            thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
        end
    end

endmodule