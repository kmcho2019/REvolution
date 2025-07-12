module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];
    
    wire ones_overflow = (ones == 4'd9);
    wire tens_overflow = (tens == 4'd9);
    wire hundreds_overflow = (hundreds == 4'd9);
    
    wire ones_inc = 1'b1;  // Always increment ones
    wire tens_inc = ones_overflow;
    wire hundreds_inc = ones_overflow & tens_overflow;
    wire thousands_inc = ones_overflow & tens_overflow & hundreds_overflow;
    
    assign q = counter;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            ena <= 3'b0;
        end
        else begin
            // Update enable signals (registered to improve timing)
            ena[0] <= ones_overflow;
            ena[1] <= ones_overflow & tens_overflow;
            ena[2] <= ones_overflow & tens_overflow & hundreds_overflow;
            
            // Update counter with clock gating for upper digits
            counter[3:0] <= ones + 1'b1;
            
            if (tens_inc) begin
                counter[7:4] <= tens_overflow ? 4'd0 : tens + 1'b1;
            end
            
            if (hundreds_inc) begin
                counter[11:8] <= hundreds_overflow ? 4'd0 : hundreds + 1'b1;
            end
            
            if (thousands_inc) begin
                counter[15:12] <= (thousands == 4'd9) ? 4'd0 : thousands + 1'b1;
            end
        end
    end

endmodule