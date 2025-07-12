module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [15:0] prev_counter;
    wire [3:0] ones, tens, hundreds, thousands;
    
    // Extract digits
    assign ones = counter[3:0];
    assign tens = counter[7:4];
    assign hundreds = counter[11:8];
    assign thousands = counter[15:12];
    
    // BCD correction logic
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            prev_counter <= 16'd0;
        end else begin
            prev_counter <= counter;
            
            // Increment counter
            counter <= counter + 16'd1;
            
            // Correct each digit if it exceeds 9
            if (ones == 4'd9) begin
                counter[3:0] <= 4'd0;
                if (tens == 4'd9) begin
                    counter[7:4] <= 4'd0;
                    if (hundreds == 4'd9) begin
                        counter[11:8] <= 4'd0;
                        if (thousands == 4'd9) begin
                            counter[15:12] <= 4'd0;
                        end else begin
                            counter[15:12] <= thousands + 4'd1;
                        end
                    end else begin
                        counter[11:8] <= hundreds + 4'd1;
                    end
                end else begin
                    counter[7:4] <= tens + 4'd1;
                end
            end
        end
    end
    
    // Generate enable signals by detecting digit changes
    assign ena[0] = (ones == 4'd9) && (prev_counter[3:0] != 4'd9);
    assign ena[1] = (tens != prev_counter[7:4]) && ena[0];
    assign ena[2] = (hundreds != prev_counter[11:8]) && ena[1];
    
    // Output the corrected BCD value
    assign q = counter;

endmodule