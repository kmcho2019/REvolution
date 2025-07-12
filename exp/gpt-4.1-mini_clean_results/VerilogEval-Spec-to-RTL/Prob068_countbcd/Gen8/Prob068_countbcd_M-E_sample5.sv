module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);
    // Registers for each BCD digit
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    // Carry signals (internal)
    reg carry_ones;
    reg carry_tens;
    reg carry_hundreds;

    // Enable outputs for upper digit increments (registered to current increments)
    reg ena_tens;
    reg ena_hundreds;
    reg ena_thousands;

    // Assign ena outputs
    assign ena = {ena_thousands, ena_hundreds, ena_tens};

    // Combine BCD digits into 16-bit output
    assign q = {thousands, hundreds, tens, ones};

    always @(posedge clk) begin
        if (reset) begin
            ones       <= 4'd0;
            tens       <= 4'd0;
            hundreds   <= 4'd0;
            thousands  <= 4'd0;

            carry_ones     <= 1'b0;
            carry_tens     <= 1'b0;
            carry_hundreds <= 1'b0;

            ena_tens      <= 1'b0;
            ena_hundreds  <= 1'b0;
            ena_thousands <= 1'b0;
        end else begin
            // Increment ones digit always by 1
            if (ones == 4'd9) begin
                ones <= 4'd0;
                carry_ones <= 1'b1;      // Generate carry out
            end else begin
                ones <= ones + 1'b1;
                carry_ones <= 1'b0;
            end

            // Increment tens digit if carry from ones
            if (carry_ones) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    carry_tens <= 1'b1;
                    ena_tens <= 1'b1;      // Enable increment output for tens digit
                end else begin
                    tens <= tens + 1'b1;
                    carry_tens <= 1'b0;
                    ena_tens <= 1'b1;
                end
            end else begin
                carry_tens <= 1'b0;
                ena_tens <= 1'b0;
            end

            // Increment hundreds digit if carry from tens
            if (carry_tens) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    carry_hundreds <= 1'b1;
                    ena_hundreds <= 1'b1;
                end else begin
                    hundreds <= hundreds + 1'b1;
                    carry_hundreds <= 1'b0;
                    ena_hundreds <= 1'b1;
                end
            end else begin
                carry_hundreds <= 1'b0;
                ena_hundreds <= 1'b0;
            end

            // Increment thousands digit if carry from hundreds
            if (carry_hundreds) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                    ena_thousands <= 1'b1;
                end else begin
                    thousands <= thousands + 1'b1;
                    ena_thousands <= 1'b1;
                end
            end else begin
                ena_thousands <= 1'b0;
            end
        end
    end

endmodule