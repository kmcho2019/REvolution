module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    
    assign q = counter;
    
    // Enable signals
    assign ena[0] = (counter[3:0] == 4'd9);
    assign ena[1] = (counter[7:4] == 4'd9) && ena[0];
    assign ena[2] = (counter[11:8] == 4'd9) && ena[1];
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Always increment ones digit
            if (counter[3:0] == 4'd9) begin
                counter[3:0] <= 4'd0;
                // Handle tens digit overflow
                if (counter[7:4] == 4'd9) begin
                    counter[7:4] <= 4'd0;
                    // Handle hundreds digit overflow
                    if (counter[11:8] == 4'd9) begin
                        counter[11:8] <= 4'd0;
                        // Handle thousands digit overflow
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
    end

endmodule