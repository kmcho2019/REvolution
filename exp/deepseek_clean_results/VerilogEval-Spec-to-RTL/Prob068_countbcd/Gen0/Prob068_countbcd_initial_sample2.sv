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
    
    // Combinational enable signals
    assign ena[0] = (ones == 4'd9);          // Enable tens when ones reaches 9
    assign ena[1] = (ones == 4'd9) && (tens == 4'd9);          // Enable hundreds when tens and ones reach 9
    assign ena[2] = (ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9);  // Enable thousands when hundreds, tens, and ones reach 9
    
    // Combine digits into output
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end
            
            // Increment tens digit if enabled
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end
            
            // Increment hundreds digit if enabled
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end
            
            // Increment thousands digit if enabled
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