module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] bcd;

    // Extract each digit from current value
    wire [3:0] ones     = bcd[3:0];
    wire [3:0] tens     = bcd[7:4];
    wire [3:0] hundreds = bcd[11:8];
    wire [3:0] thousands= bcd[15:12];

    // Generate enable signals: when lower digit rolls over from 9 to 0
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            bcd <= 16'd0;
        end else begin
            // Increment ones digit
            if (ones == 4'd9) begin
                // ones rolls over to 0, increment tens
                if (tens == 4'd9) begin
                    // tens rolls over to 0, increment hundreds
                    if (hundreds == 4'd9) begin
                        // hundreds rolls over to 0, increment thousands
                        if (thousands == 4'd9) begin
                            // all digits roll over to 0
                            bcd <= 16'd0;
                        end else begin
                            bcd[15:12] <= thousands + 1'b1;
                            bcd[11:0]  <= 12'd0;
                        end
                    end else begin
                        bcd[11:8] <= hundreds + 1'b1;
                        bcd[7:0]  <= 8'd0;
                    end
                end else begin
                    bcd[7:4] <= tens + 1'b1;
                    bcd[3:0] <= 4'd0;
                end
            end else begin
                bcd[3:0] <= ones + 1'b1;
            end
        end
    end

    assign q = bcd;

endmodule