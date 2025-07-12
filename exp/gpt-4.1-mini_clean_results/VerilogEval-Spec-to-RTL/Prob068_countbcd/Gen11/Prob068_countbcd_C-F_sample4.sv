module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    // Extract digits for enable signal generation
    wire [3:0] ones      = bcd_count[3:0];
    wire [3:0] tens      = bcd_count[7:4];
    wire [3:0] hundreds  = bcd_count[11:8];
    wire [3:0] thousands = bcd_count[15:12];

    // ena signals indicate when the next digit should increment (i.e., lower digit is 9)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Function to increment a single BCD digit with carry-out
    function [4:0] bcd_increment;
        input [3:0] digit_in;
    begin
        if (digit_in == 4'd9)
            bcd_increment = {1'b1, 4'd0}; // carry out, digit resets to 0
        else
            bcd_increment = {1'b0, digit_in + 1'b1}; // no carry, digit + 1
    end
    endfunction

    // Sequential logic for counting with carry propagation using the increment function
    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            // Increment ones digit
            reg [4:0] inc_ones, inc_tens, inc_hundreds, inc_thousands;
            inc_ones = bcd_increment(bcd_count[3:0]);

            // If carry from ones digit, increment tens digit
            if (inc_ones[4]) begin
                inc_tens = bcd_increment(bcd_count[7:4]);
                // If carry from tens digit, increment hundreds digit
                if (inc_tens[4]) begin
                    inc_hundreds = bcd_increment(bcd_count[11:8]);
                    // If carry from hundreds digit, increment thousands digit
                    if (inc_hundreds[4]) begin
                        inc_thousands = bcd_increment(bcd_count[15:12]);
                        bcd_count <= {inc_thousands[3:0], inc_hundreds[3:0], inc_tens[3:0], inc_ones[3:0]};
                    end else begin
                        bcd_count <= {bcd_count[15:12], inc_hundreds[3:0], inc_tens[3:0], inc_ones[3:0]};
                    end
                end else begin
                    bcd_count <= {bcd_count[15:12], bcd_count[11:8], inc_tens[3:0], inc_ones[3:0]};
                end
            end else begin
                bcd_count <= {bcd_count[15:12], bcd_count[11:8], bcd_count[7:4], inc_ones[3:0]};
            end
        end
    end

    assign q = bcd_count;

endmodule