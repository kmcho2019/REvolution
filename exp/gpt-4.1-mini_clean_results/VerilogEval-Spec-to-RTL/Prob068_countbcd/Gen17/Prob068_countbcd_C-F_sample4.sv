module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    // Extract individual digits for combinational logic
    wire [3:0] ones      = bcd_count[3:0];
    wire [3:0] tens      = bcd_count[7:4];
    wire [3:0] hundreds  = bcd_count[11:8];
    wire [3:0] thousands = bcd_count[15:12];

    // Enable signals indicate when the next digit should increment (lower digit == 9)
    assign ena[0] = (ones == 4'd9);                        // enable tens increment
    assign ena[1] = ena[0] && (tens == 4'd9);              // enable hundreds increment
    assign ena[2] = ena[1] && (hundreds == 4'd9);          // enable thousands increment

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            // Start with incrementing the ones digit
            if (ones == 4'd9) begin
                // Ones rolls over to 0, increment tens
                if (tens == 4'd9) begin
                    // Tens rolls over to 0, increment hundreds
                    if (hundreds == 4'd9) begin
                        // Hundreds rolls over to 0, increment thousands
                        if (thousands == 4'd9) begin
                            // All digits roll over to 0
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