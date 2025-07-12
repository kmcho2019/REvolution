module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    assign q = counter;
    
    // Enable signals
    assign ena[0] = (counter[3:0] == 4'd9);                     // tens enable
    assign ena[1] = (counter[7:4] == 4'd9) & ena[0];            // hundreds enable
    assign ena[2] = (counter[11:8] == 4'd9) & ena[1];           // thousands enable
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Increment logic with BCD rollover
            if (counter[3:0] == 4'd9) begin
                counter[3:0] <= 4'd0;
                if (counter[7:4] == 4'd9) begin
                    counter[7:4] <= 4'd0;
                    if (counter[11:8] == 4'd9) begin
                        counter[11:8] <= 4'd0;
                        if (counter[15:12] == 4'd9) begin
                            counter[15:12] <= 4'd0;
                        end
                        else begin
                            counter[15:12] <= counter[15:12] + 4'd1;
                        end
                    end
                    else begin
                        counter[11:8] <= counter[11:8] + 4'd1;
                    end
                end
                else begin
                    counter[7:4] <= counter[7:4] + 4'd1;
                end
            end
            else begin
                counter[3:0] <= counter[3:0] + 4'd1;
            end
        end
    end

endmodule