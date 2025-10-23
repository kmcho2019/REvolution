module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    // Extract digits for convenience
    wire [3:0] ones      = bcd_count[3:0];
    wire [3:0] tens      = bcd_count[7:4];
    wire [3:0] hundreds  = bcd_count[11:8];
    wire [3:0] thousands = bcd_count[15:12];

    // Enable signals indicate when each upper digit should be incremented,
    // i.e. when the lower digit is 9 (about to roll over)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            // Increment ones digit
            if (ones == 4'd9) begin
                // ones roll over to 0
                bcd_count[3:0] <= 4'd0;

                // Increment tens digit if enabled
                if (tens == 4'd9) begin
                    bcd_count[7:4] <= 4'd0;

                    // Increment hundreds digit if enabled
                    if (hundreds == 4'd9) begin
                        bcd_count[11:8] <= 4'd0;

                        // Increment thousands digit if enabled
                        if (thousands == 4'd9) begin
                            // Roll over thousands to 0 on 9999+1
                            bcd_count[15:12] <= 4'd0;
                        end else begin
                            bcd_count[15:12] <= thousands + 1'b1;
                        end

                    end else begin
                        bcd_count[11:8] <= hundreds + 1'b1;
                    end

                end else begin
                    bcd_count[7:4] <= tens + 1'b1;
                end

            end else begin
                // No rollover of ones, just increment ones digit
                bcd_count[3:0] <= ones + 1'b1;
            end
        end
    end

    assign q = bcd_count;

endmodule