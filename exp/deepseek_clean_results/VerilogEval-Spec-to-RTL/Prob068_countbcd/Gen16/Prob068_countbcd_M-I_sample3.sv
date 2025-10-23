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
    
    assign q = counter;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            ena <= 3'b0;
        end
        else begin
            // Register enable signals
            ena[0] <= ones_overflow;
            ena[1] <= ones_overflow && tens_overflow;
            ena[2] <= ones_overflow && tens_overflow && hundreds_overflow;
            
            // Update counter with parallel logic
            if (ones_overflow) begin
                counter[3:0] <= 4'd0;
                if (tens_overflow) begin
                    counter[7:4] <= 4'd0;
                    if (hundreds_overflow) begin
                        counter[11:8] <= 4'd0;
                        if (thousands == 4'd9)
                            counter[15:12] <= 4'd0;
                        else
                            counter[15:12] <= thousands + 1'b1;
                    end
                    else begin
                        counter[11:8] <= hundreds + 1'b1;
                    end
                end
                else begin
                    counter[7:4] <= tens + 1'b1;
                end
            end
            else begin
                counter[3:0] <= ones + 1'b1;
            end
        end
    end

endmodule