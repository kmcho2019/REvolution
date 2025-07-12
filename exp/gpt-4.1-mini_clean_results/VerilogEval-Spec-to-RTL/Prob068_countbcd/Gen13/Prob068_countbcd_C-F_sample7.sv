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

    // Enable signals indicate when each upper digit should increment
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Function to increment a single BCD digit with carry out
    function [4:0] bcd_increment;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_increment = {1'b1, 4'd0}; // carry out, digit resets to 0
            else
                bcd_increment = {1'b0, digit + 1'b1}; // no carry, digit + 1
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            // Intermediate results for each digit increment and carry
            reg [4:0] ones_inc, tens_inc, hundreds_inc, thousands_inc;

            ones_inc     = bcd_increment(ones);

            if (ones_inc[4]) begin // carry from ones to tens
                tens_inc = bcd_increment(tens);

                if (tens_inc[4]) begin // carry from tens to hundreds
                    hundreds_inc = bcd_increment(hundreds);

                    if (hundreds_inc[4]) begin // carry from hundreds to thousands
                        thousands_inc = bcd_increment(thousands);
                        bcd_count <= {thousands_inc[3:0], hundreds_inc[3:0], tens_inc[3:0], ones_inc[3:0]};
                    end else begin
                        bcd_count <= {thousands, hundreds_inc[3:0], tens_inc[3:0], ones_inc[3:0]};
                    end
                end else begin
                    bcd_count <= {thousands, hundreds, tens_inc[3:0], ones_inc[3:0]};
                end
            end else begin
                bcd_count <= {thousands, hundreds, tens, ones_inc[3:0]};
            end
        end
    end

    assign q = bcd_count;

endmodule