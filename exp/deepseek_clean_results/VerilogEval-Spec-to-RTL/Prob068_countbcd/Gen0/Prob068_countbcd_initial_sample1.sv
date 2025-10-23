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
    
    // Enable signals for upper three digits
    assign ena[0] = (ones == 4'd9);       // tens enable
    assign ena[1] = (ones == 4'd9) && (tens == 4'd9); // hundreds enable
    assign ena[2] = (ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9); // thousands enable
    
    // Combine digits into output
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end
        else begin
            // Always increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end
            
            // Increment tens when ones rolls over
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end
            
            // Increment hundreds when tens rolls over
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end
            
            // Increment thousands when hundreds rolls over
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

endmodule