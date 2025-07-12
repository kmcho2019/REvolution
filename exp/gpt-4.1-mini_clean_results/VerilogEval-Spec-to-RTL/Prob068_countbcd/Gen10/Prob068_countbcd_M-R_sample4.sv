module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    wire ones_rollover, tens_rollover, hundreds_rollover;
    reg  [3:0] ones_next, tens_next, hundreds_next, thousands_next;

    // Detect rollovers
    assign ones_rollover    = (ones == 4'd9);
    assign tens_rollover    = (tens == 4'd9);
    assign hundreds_rollover= (hundreds == 4'd9);

    // Enable signals: when each digit should increment
    assign ena[0] = ones_rollover;                            // tens increment enable
    assign ena[1] = ones_rollover && tens_rollover;           // hundreds increment enable
    assign ena[2] = ones_rollover && tens_rollover && hundreds_rollover; // thousands increment enable

    // Combinational next state logic
    always @* begin
        // Ones digit increments every clock
        if (ones_rollover)
            ones_next = 4'd0;
        else
            ones_next = ones + 1'b1;

        // Tens digit increments when ones roll over
        if (ones_rollover) begin
            if (tens_rollover)
                tens_next = 4'd0;
            else
                tens_next = tens + 1'b1;
        end else begin
            tens_next = tens;
        end

        // Hundreds digit increments when tens roll over while ones rollover
        if (ones_rollover && tens_rollover) begin
            if (hundreds_rollover)
                hundreds_next = 4'd0;
            else
                hundreds_next = hundreds + 1'b1;
        end else begin
            hundreds_next = hundreds;
        end

        // Thousands digit increments when hundreds roll over while tens and ones roll over
        if (ones_rollover && tens_rollover && hundreds_rollover) begin
            if (thousands == 4'd9)
                thousands_next = 4'd0;
            else
                thousands_next = thousands + 1'b1;
        end else begin
            thousands_next = thousands;
        end
    end

    // Sequential update of registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            ones      <= ones_next;
            tens      <= tens_next;
            hundreds  <= hundreds_next;
            thousands <= thousands_next;
        end
    end

    // Output packing
    assign q = {thousands, hundreds, tens, ones};

endmodule