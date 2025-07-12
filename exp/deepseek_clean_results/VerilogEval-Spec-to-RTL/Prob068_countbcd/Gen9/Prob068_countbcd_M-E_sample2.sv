module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Separate registers for each digit
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;
    
    // Pipeline registers
    reg ones_rollover;
    reg tens_rollover;
    reg hundreds_rollover;
    
    assign q = {thousands, hundreds, tens, ones};
    
    // Parallel enable signal generation
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9);
    assign ena[2] = (hundreds == 4'd9);
    
    // Stage 1: Calculate rollover conditions
    always @(posedge clk) begin
        if (reset) begin
            ones_rollover <= 1'b0;
            tens_rollover <= 1'b0;
            hundreds_rollover <= 1'b0;
        end else begin
            ones_rollover <= (ones == 4'd9);
            tens_rollover <= (tens == 4'd9) & ones_rollover;
            hundreds_rollover <= (hundreds == 4'd9) & tens_rollover;
        end
    end
    
    // Stage 2: Update digit values
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit always increments
            if (ones == 4'd9) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end
            
            // Tens digit increments when ones rolls over
            if (ones_rollover) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end
            
            // Hundreds digit increments when tens rolls over
            if (tens_rollover) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end
            
            // Thousands digit increments when hundreds rolls over
            if (hundreds_rollover) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

endmodule