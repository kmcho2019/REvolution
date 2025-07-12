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
    reg [15:0] q_reg;
    
    assign q = q_reg;
    
    // Enable signals - optimized to avoid redundant comparisons
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);
    
    assign ena[0] = ones_rollover;                     // tens enable
    assign ena[1] = ones_rollover && tens_rollover;    // hundreds enable
    assign ena[2] = ones_rollover && tens_rollover && hundreds_rollover; // thousands enable
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            q_reg <= 16'd0;
        end
        else begin
            // Ones digit - always increments
            if (ones_rollover) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end
            
            // Tens digit - increments only when ones rolls over
            if (ones_rollover) begin
                if (tens_rollover) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end
            
            // Hundreds digit - increments only when tens rolls over
            if (ena[1]) begin
                if (hundreds_rollover) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end
            
            // Thousands digit - increments only when hundreds rolls over
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
            
            // Registered output to reduce switching power
            q_reg <= {thousands, hundreds, tens, ones};
        end
    end

endmodule