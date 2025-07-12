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
    
    // Rollover detection
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);
    
    // Enable signals
    assign ena[0] = 1'b1;  // ones always enabled
    assign ena[1] = (ones == 4'd9);  // tens enable on ones rollover
    assign ena[2] = (ones == 4'd9) && (tens == 4'd9);  // hundreds enable on both rollovers
    
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'b0;
            tens <= 4'b0;
            hundreds <= 4'b0;
            thousands <= 4'b0;
        end else begin
            // Ones digit (always increments)
            if (ones == 4'd9) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end
            
            // Tens digit (increments on ones rollover)
            if (ones_rollover) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end
            
            // Hundreds digit (increments on ones+tens rollover)
            if (ones_rollover && tens_rollover) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end
            
            // Thousands digit (increments on all lower digits rollover)
            if (ones_rollover && tens_rollover && hundreds_rollover) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

endmodule