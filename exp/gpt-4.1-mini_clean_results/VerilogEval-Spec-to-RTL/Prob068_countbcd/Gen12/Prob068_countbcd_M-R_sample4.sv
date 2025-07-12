module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg ena_tens, ena_hundreds, ena_thousands;

    // Pack output q
    assign q = {thousands, hundreds, tens, ones};
    assign ena = {ena_thousands, ena_hundreds, ena_tens};

    // BCD increment function with carry-out
    function [4:0] bcd_inc;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc = {1'b1, 4'd0};
            else
                bcd_inc = {1'b0, digit + 1'b1};
        end
    endfunction

    // Registers to hold intermediate carry signals for ripple carry
    reg carry_ones, carry_tens, carry_hundreds;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;

            // Clear enables on reset
            ena_tens      <= 1'b0;
            ena_hundreds  <= 1'b0;
            ena_thousands <= 1'b0;

            carry_ones     <= 1'b0;
            carry_tens     <= 1'b0;
            carry_hundreds <= 1'b0;

        end else begin
            // Increment ones digit every clock
            reg [4:0] inc_ones = bcd_inc(ones);
            ones <= inc_ones[3:0];
            carry_ones <= inc_ones[4];
            ena_tens <= inc_ones[4]; // tens enable when ones roll over

            // Increment tens digit if enabled by ones carry
            if (ena_tens) begin
                reg [4:0] inc_tens = bcd_inc(tens);
                tens <= inc_tens[3:0];
                carry_tens <= inc_tens[4];
                ena_hundreds <= inc_tens[4];
            end else begin
                carry_tens <= 1'b0;
                ena_hundreds <= 1'b0;
                tens <= tens;
            end

            // Increment hundreds digit if enabled by tens carry
            if (ena_hundreds) begin
                reg [4:0] inc_hundreds = bcd_inc(hundreds);
                hundreds <= inc_hundreds[3:0];
                carry_hundreds <= inc_hundreds[4];
                ena_thousands <= inc_hundreds[4];
            end else begin
                carry_hundreds <= 1'b0;
                ena_thousands <= 1'b0;
                hundreds <= hundreds;
            end

            // Increment thousands digit if enabled by hundreds carry
            if (ena_thousands) begin
                reg [4:0] inc_thousands = bcd_inc(thousands);
                thousands <= inc_thousands[3:0];
                // No carry beyond thousands, so no further enable
            end else begin
                thousands <= thousands;
            end
        end
    end

endmodule