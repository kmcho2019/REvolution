module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Rollover signals
    wire rollover_ones = (ones == 4'd9);
    wire rollover_tens = (tens == 4'd9) & rollover_ones;
    wire rollover_hundreds = (hundreds == 4'd9) & rollover_tens;
    
    // Assign enable outputs
    assign ena = {rollover_hundreds, rollover_tens, rollover_ones};
    
    // Concatenate output
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit - always increments
            if (ones == 4'd9) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end
            
            // Tens digit - increments on ones rollover
            if (rollover_ones) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end
            
            // Hundreds digit - increments on tens rollover
            if (rollover_tens) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end
            
            // Thousands digit - increments on hundreds rollover
            if (rollover_hundreds) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

endmodule