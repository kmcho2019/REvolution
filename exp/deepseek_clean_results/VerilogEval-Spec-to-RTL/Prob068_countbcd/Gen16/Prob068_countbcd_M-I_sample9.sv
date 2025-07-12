module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Parallel enable generation (breaks critical path)
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (ones == 4'd9) & (tens == 4'd9);
    wire hundreds_rollover = (ones == 4'd9) & (tens == 4'd9) & (hundreds == 4'd9);
    
    assign ena = {hundreds_rollover, tens_rollover, ones_rollover};

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Always increment ones digit
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
            
            // Conditionally increment other digits only when needed
            if (ones_rollover) begin
                tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
            end
            
            if (tens_rollover) begin
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
            end
            
            if (hundreds_rollover) begin
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule