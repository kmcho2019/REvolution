module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Enable signals: indicate when the next upper digit should increment
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Function to increment a BCD digit with carry out
    function [4:0] bcd_inc;
        input [3:0] digit;
    begin
        if (digit == 4'd9)
            bcd_inc = {1'b1, 4'd0}; // carry out, digit reset to 0
        else
            bcd_inc = {1'b0, digit + 4'd1};
    end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit
            reg [4:0] ones_inc, tens_inc, hundreds_inc, thousands_inc;
            ones_inc = bcd_inc(ones);

            if (ones_inc[4]) begin // carry from ones
                tens_inc = bcd_inc(tens);
                if (tens_inc[4]) begin // carry from tens
                    hundreds_inc = bcd_inc(hundreds);
                    if (hundreds_inc[4]) begin // carry from hundreds
                        thousands_inc = bcd_inc(thousands);
                        thousands <= thousands_inc[3:0];
                    end else
                        thousands <= thousands;
                    hundreds  <= hundreds_inc[3:0];
                end else begin
                    hundreds <= hundreds;
                    thousands <= thousands;
                end
                tens <= tens_inc[3:0];
            end else begin
                tens <= tens;
                hundreds <= hundreds;
                thousands <= thousands;
            end
            ones <= ones_inc[3:0];
        end
    end

    // Pack digits into 16-bit output
    assign q = {thousands, hundreds, tens, ones};

endmodule