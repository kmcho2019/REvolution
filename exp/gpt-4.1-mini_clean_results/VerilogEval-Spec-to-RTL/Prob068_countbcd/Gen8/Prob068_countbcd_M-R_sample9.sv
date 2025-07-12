module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    // Extract digits for clarity
    wire [3:0] ones     = bcd_count[3:0];
    wire [3:0] tens     = bcd_count[7:4];
    wire [3:0] hundreds = bcd_count[11:8];
    wire [3:0] thousands= bcd_count[15:12];

    // Carry signals indicate if a digit just rolled over from 9->0
    wire carry_ones     = (ones == 4'd9);
    wire carry_tens     = carry_ones     && (tens == 4'd9);
    wire carry_hundreds = carry_tens     && (hundreds == 4'd9);

    // Enable signals show when the upper digit should increment (ones carry to tens, tens carry to hundreds, hundreds carry to thousands)
    assign ena[0] = carry_ones;
    assign ena[1] = carry_tens;
    assign ena[2] = carry_hundreds;

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            // Increment ones digit with ripple carry to tens, hundreds, thousands if needed
            if (carry_hundreds && thousands == 4'd9) begin
                // All digits are 9, rollover to zero
                bcd_count <= 16'd0;
            end else begin
                if (carry_ones) begin
                    // ones digit rolls over to 0, increment tens
                    if (carry_tens) begin
                        // tens digit rolls over to 0, increment hundreds
                        if (carry_hundreds) begin
                            // hundreds digit rolls over to 0, increment thousands
                            bcd_count <= { (thousands + 1'b1) % 10, 4'd0, 4'd0, 4'd0 };
                        end else begin
                            bcd_count <= { thousands, (hundreds + 1'b1) % 10, 4'd0, 4'd0 };
                        end
                    end else begin
                        bcd_count <= { thousands, hundreds, (tens + 1'b1) % 10, 4'd0 };
                    end
                end else begin
                    // Increment ones digit normally
                    bcd_count <= bcd_count + 16'd1;
                end
            end
        end
    end

    assign q = bcd_count;

endmodule