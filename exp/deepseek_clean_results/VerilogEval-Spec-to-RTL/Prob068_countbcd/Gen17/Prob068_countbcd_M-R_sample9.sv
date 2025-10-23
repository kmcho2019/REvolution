module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Combinational enable logic
    assign ena[0] = (ones == 4'd9);         // ones rollover
    assign ena[1] = (tens == 4'd9) & ena[0]; // tens rollover
    assign ena[2] = (hundreds == 4'd9) & ena[1]; // hundreds rollover
    
    // Combined synchronous logic for all digits
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit (always increments)
            if (ones == 4'd9) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end
            
            // Tens digit (increments on ones rollover)
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end
            
            // Hundreds digit (increments on tens rollover)
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end
            
            // Thousands digit (increments on hundreds rollover)
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end
    
    // Output concatenation
    assign q = {thousands, hundreds, tens, ones};

endmodule