module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [15:0] counter_prev;
    
    // Main counter
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            if (counter[3:0] == 4'd9) begin
                counter[3:0] <= 4'd0;
                if (counter[7:4] == 4'd9) begin
                    counter[7:4] <= 4'd0;
                    if (counter[11:8] == 4'd9) begin
                        counter[11:8] <= 4'd0;
                        if (counter[15:12] == 4'd9) begin
                            counter[15:12] <= 4'd0;
                        end else begin
                            counter[15:12] <= counter[15:12] + 4'd1;
                        end
                    end else begin
                        counter[11:8] <= counter[11:8] + 4'd1;
                    end
                end else begin
                    counter[7:4] <= counter[7:4] + 4'd1;
                end
            end else begin
                counter[3:0] <= counter[3:0] + 4'd1;
            end
        end
        counter_prev <= counter;
    end
    
    // Digit extraction
    assign q = counter;
    
    // Enable generation
    assign ena[0] = (counter_prev[3:0] == 4'd9) && (counter[3:0] == 4'd0);
    assign ena[1] = (counter_prev[7:0] == 8'h99) && (counter[7:0] == 8'h00);
    assign ena[2] = (counter_prev[11:0] == 12'h999) && (counter[11:0] == 12'h000);

endmodule