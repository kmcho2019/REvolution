module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    wire [3:0] ones      = bcd_count[3:0];
    wire [3:0] tens      = bcd_count[7:4];
    wire [3:0] hundreds  = bcd_count[11:8];
    wire [3:0] thousands = bcd_count[15:12];

    // ena signals indicate when each digit should increment:
    // For digits 1 to 3 (tens, hundreds, thousands),
    // ena[i] is high when the lower digit is 9
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9);
    assign ena[2] = (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            // Increment ones digit
            if (ones == 4'd9) begin
                // ones roll over to 0 and increment tens
                if (tens == 4'd9) begin
                    // tens roll over to 0 and increment hundreds
                    if (hundreds == 4'd9) begin
                        // hundreds roll over to 0 and increment thousands
                        if (thousands == 4'd9) begin
                            // thousands roll over to 0 (counter resets)
                            bcd_count <= 16'd0;
                        end else begin
                            bcd_count <= {thousands + 1'b1, 4'd0, 4'd0, 4'd0};
                        end
                    end else begin
                        bcd_count <= {thousands, hundreds + 1'b1, 4'd0, 4'd0};
                    end
                end else begin
                    bcd_count <= {thousands, hundreds, tens + 1'b1, 4'd0};
                end
            end else begin
                bcd_count <= {thousands, hundreds, tens, ones + 1'b1};
            end
        end
    end

    assign q = bcd_count;

endmodule