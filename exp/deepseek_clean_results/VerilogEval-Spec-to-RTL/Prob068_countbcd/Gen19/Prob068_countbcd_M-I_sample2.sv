module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg ones_ena, tens_ena, hundreds_ena;
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ones_ena <= 1'b0;
            tens_ena <= 1'b0;
            hundreds_ena <= 1'b0;
        end else begin
            // Default enable values
            ones_ena <= 1'b1;
            tens_ena <= (ones == 4'd9);
            hundreds_ena <= (ones == 4'd9) && (tens == 4'd9);
            
            // Update ones digit (always increments)
            if (ones == 4'd9) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end
            
            // Update tens digit (only when ones rolls over)
            if (tens_ena) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end
            
            // Update hundreds digit (only when tens rolls over)
            if (hundreds_ena) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end
            
            // Update thousands digit (only when hundreds rolls over)
            if ((ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9)) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end
    
    assign q = {thousands, hundreds, tens, ones};
    assign ena = {hundreds_ena, tens_ena, ones_ena};

endmodule