module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];
    
    assign q = counter;
    
    // Enable signals
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9) & ena[0];
    assign ena[2] = (hundreds == 4'd9) & ena[1];
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Increment ones digit
            if (ones != 4'd9) begin
                counter[3:0] <= ones + 1'b1;
            end
            else begin
                counter[3:0] <= 4'd0;
                // Increment tens digit
                if (tens != 4'd9) begin
                    counter[7:4] <= tens + 1'b1;
                end
                else begin
                    counter[7:4] <= 4'd0;
                    // Increment hundreds digit
                    if (hundreds != 4'd9) begin
                        counter[11:8] <= hundreds + 1'b1;
                    end
                    else begin
                        counter[11:8] <= 4'd0;
                        // Increment thousands digit
                        if (thousands != 4'd9) begin
                            counter[15:12] <= thousands + 1'b1;
                        end
                        else begin
                            counter[15:12] <= 4'd0;
                        end
                    end
                end
            end
        end
    end

endmodule