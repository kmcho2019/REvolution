module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    assign q = counter;
    
    // Precompute all rollover conditions once
    wire ones_rollover = (counter[3:0] == 4'd9);
    wire tens_rollover = (counter[7:4] == 4'd9);
    wire hundreds_rollover = (counter[11:8] == 4'd9);
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            ena <= 3'b000;
        end
        else begin
            // Update enable signals first (registered to break timing path)
            ena[0] <= ones_rollover;
            ena[1] <= ones_rollover && tens_rollover;
            ena[2] <= ones_rollover && tens_rollover && hundreds_rollover;
            
            // Always increment ones digit
            counter[3:0] <= (counter[3:0] + 1) % 10;
            
            // Conditional increment for higher digits
            if (ones_rollover) begin
                counter[7:4] <= (counter[7:4] + 1) % 10;
                
                if (tens_rollover) begin
                    counter[11:8] <= (counter[11:8] + 1) % 10;
                    
                    if (hundreds_rollover) begin
                        counter[15:12] <= (counter[15:12] + 1) % 10;
                    end
                end
            end
        end
    end

endmodule