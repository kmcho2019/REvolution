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

    // Enable signals: upper digit increments when lower digit is 9
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Combinational next-digit increment with carry out
    function [4:0] bcd_increment;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_increment = {1'b1, 4'd0}; // carry out, digit resets to 0
            else
                bcd_increment = {1'b0, digit + 1'b1};
        end
    endfunction

    wire [4:0] ones_next      = bcd_increment(ones);
    wire [4:0] tens_next      = bcd_increment(tens);
    wire [4:0] hundreds_next  = bcd_increment(hundreds);
    wire [4:0] thousands_next = bcd_increment(thousands);

    reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;

    always @* begin
        // Default next state to current digits (no carry increments)
        next_ones      = ones_next[3:0];
        next_tens      = tens;
        next_hundreds  = hundreds;
        next_thousands = thousands;

        if (ones_next[4]) begin
            // Ones rolled over, increment tens
            next_tens = tens_next[3:0];
            if (tens_next[4]) begin
                // Tens rolled over, increment hundreds
                next_hundreds = hundreds_next[3:0];
                if (hundreds_next[4]) begin
                    // Hundreds rolled over, increment thousands
                    next_thousands = thousands_next[3:0];
                end
            end
        end
    end

    always @(posedge clk) begin
        if (reset)
            bcd_count <= 16'd0;
        else
            bcd_count <= {next_thousands, next_hundreds, next_tens, next_ones};
    end

    assign q = bcd_count;

endmodule