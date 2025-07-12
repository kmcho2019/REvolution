module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    assign q = counter;
    
    // Enable signals: ena[0]=tens, ena[1]=hundreds, ena[2]=thousands
    assign ena[0] = (counter[3:0] == 4'd9);
    assign ena[1] = (counter[7:0] == 8'd99);
    assign ena[2] = (counter[11:0] == 12'd999);
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Increment ones digit
            if (counter[3:0] == 4'd9) begin
                counter[3:0] <= 4'd0;
                // Increment tens digit
                if (counter[7:4] == 4'd9) begin
                    counter[7:4] <= 4'd0;
                    // Increment hundreds digit
                    if (counter[11:8] == 4'd9) begin
                        counter[11:8] <= 4'd0;
                        // Increment thousands digit
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