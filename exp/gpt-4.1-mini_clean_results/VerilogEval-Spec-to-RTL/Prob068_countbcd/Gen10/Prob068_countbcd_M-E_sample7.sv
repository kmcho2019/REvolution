module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] count;

    wire [3:0] digit0, digit1, digit2, digit3;
    wire [3:0] sum0, sum1, sum2, sum3;
    wire       c1, c2, c3, c4;

    // Extract BCD digits
    assign digit0 = count[3:0];
    assign digit1 = count[7:4];
    assign digit2 = count[11:8];
    assign digit3 = count[15:12];

    // Step 1: Add 1 to ones digit
    // Detect if digit0 + 1 > 9 (BCD invalid) to generate carry c1
    assign {c1, sum0} = digit0 + 4'd1;

    // If digit0 + 1 > 9, add 6 to correct BCD and carry out
    wire [4:0] corrected0 = (digit0 + 4'd1) > 9 ? (digit0 + 4'd1 + 4'd6) : (digit0 + 4'd1);
    // sum0 already includes carry c1 from normal addition; we need to correct sum0 to valid BCD digit:
    wire [3:0] corr_sum0 = corrected0[3:0];

    // Step 2: Add carry c1 to tens digit
    assign {c2, sum1} = digit1 + c1;

    // Correct tens digit if overflow > 9
    wire [4:0] corrected1 = (digit1 + c1) > 9 ? (digit1 + c1 + 4'd6) : (digit1 + c1);
    wire [3:0] corr_sum1 = corrected1[3:0];

    // Step 3: Add carry c2 to hundreds digit
    assign {c3, sum2} = digit2 + c2;

    // Correct hundreds digit if overflow > 9
    wire [4:0] corrected2 = (digit2 + c2) > 9 ? (digit2 + c2 + 4'd6) : (digit2 + c2);
    wire [3:0] corr_sum2 = corrected2[3:0];

    // Step 4: Add carry c3 to thousands digit
    assign {c4, sum3} = digit3 + c3;

    // Correct thousands digit if overflow > 9
    wire [4:0] corrected3 = (digit3 + c3) > 9 ? (digit3 + c3 + 4'd6) : (digit3 + c3);
    wire [3:0] corr_sum3 = corrected3[3:0];

    // ena signals indicate when each upper digit increments (carry in to that digit)
    assign ena[0] = c1; // increment tens when ones roll over
    assign ena[1] = c2; // increment hundreds when tens roll over
    assign ena[2] = c3; // increment thousands when hundreds roll over

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            // Update all digits with corrected BCD values
            count <= {corr_sum3, corr_sum2, corr_sum1, corr_sum0};
        end
    end

    assign q = count;

endmodule