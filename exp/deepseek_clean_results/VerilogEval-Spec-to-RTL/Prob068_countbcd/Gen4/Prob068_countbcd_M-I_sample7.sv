module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [15:0] counter;
    wire ones_overflow = (counter[3:0] == 4'd9);
    wire tens_overflow = (counter[7:4] == 4'd9) && ones_overflow;
    wire hundreds_overflow = (counter[11:8] == 4'd9) && tens_overflow;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            ena <= 3'd0;
        end
        else begin
            // Update enable signals
            ena[0] <= ones_overflow;
            ena[1] <= tens_overflow;
            ena[2] <= hundreds_overflow;
            
            // Increment logic
            if (ones_overflow) begin
                counter[3:0] <= 4'd0;
                if (tens_overflow) begin
                    counter[7:4] <= 4'd0;
                    if (hundreds_overflow) begin
                        counter[11:8] <= 4'd0;
                        if (counter[15:12] == 4'd9)
                            counter[15:12] <= 4'd0;
                        else
                            counter[15:12] <= counter[15:12] + 4'd1;
                    end
                    else
                        counter[11:8] <= counter[11:8] + 4'd1;
                end
                else
                    counter[7:4] <= counter[7:4] + 4'd1;
            end
            else
                counter[3:0] <= counter[3:0] + 4'd1;
        end
        
        // Registered output
        q <= counter;
    end

endmodule