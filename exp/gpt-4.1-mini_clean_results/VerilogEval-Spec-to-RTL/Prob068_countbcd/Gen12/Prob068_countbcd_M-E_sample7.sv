module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg       ena_tens, ena_hundreds, ena_thousands;

    // Generate ena signals for upper digits
    // ena[0]: enable tens when ones digit rolls over from 9 to 0
    // ena[1]: enable hundreds when tens digit rolls over from 9 to 0
    // ena[2]: enable thousands when hundreds digit rolls over from 9 to 0
    assign ena = {ena_thousands, ena_hundreds, ena_tens};

    // Helper wires to detect rollover from 9 to 0 for each digit
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);

    // Ones digit increments every clock cycle unless reset
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
        end else if (ones_rollover) begin
            ones <= 4'd0;
        end else begin
            ones <= ones + 1'b1;
        end
    end

    // Enable signal to tens is asserted when ones roll over (i.e., ones == 9 before increment)
    always @(posedge clk) begin
        if (reset)
            ena_tens <= 1'b0;
        else
            ena_tens <= ones_rollover;
    end

    // Tens digit increments only on ena_tens enable
    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'd0;
        end else if (ena_tens) begin
            if (tens_rollover)
                tens <= 4'd0;
            else
                tens <= tens + 1'b1;
        end
    end

    // Enable signal to hundreds is asserted when tens roll over and tens incremented (ena_tens)
    always @(posedge clk) begin
        if (reset)
            ena_hundreds <= 1'b0;
        else
            ena_hundreds <= ena_tens && tens_rollover;
    end

    // Hundreds digit increments only on ena_hundreds enable
    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
        end else if (ena_hundreds) begin
            if (hundreds_rollover)
                hundreds <= 4'd0;
            else
                hundreds <= hundreds + 1'b1;
        end
    end

    // Enable signal to thousands is asserted when hundreds roll over and hundreds incremented (ena_hundreds)
    always @(posedge clk) begin
        if (reset)
            ena_thousands <= 1'b0;
        else
            ena_thousands <= ena_hundreds && hundreds_rollover;
    end

    // Thousands digit increments only on ena_thousands enable
    always @(posedge clk) begin
        if (reset) begin
            thousands <= 4'd0;
        end else if (ena_thousands) begin
            if (thousands == 4'd9)
                thousands <= 4'd0;
            else
                thousands <= thousands + 1'b1;
        end
    end

    // Pack digits into output vector q
    assign q = {thousands, hundreds, tens, ones};

endmodule