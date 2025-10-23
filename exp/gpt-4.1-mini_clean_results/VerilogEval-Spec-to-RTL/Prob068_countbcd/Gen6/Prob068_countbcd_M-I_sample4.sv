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

    // Enables indicate when lower digit is 9, thus the next digit increments
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Function to increment one BCD digit with carry
    function [4:0] bcd_inc;
        input [3:0] digit;
    begin
        if (digit == 4'd9)
            bcd_inc = {1'b1, 4'd0}; // carry out, digit resets to 0
        else
            bcd_inc = {1'b0, digit + 1'b1}; // no carry, digit+1
    end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            // Increment ones digit
            reg [4:0] ones_inc, tens_inc, hundreds_inc, thousands_inc;

            ones_inc = bcd_inc(ones);
            // Update tens only if ones caused carry
            if (ones_inc[4]) begin
                tens_inc = bcd_inc(tens);
                // Update hundreds only if tens caused carry
                if (tens_inc[4]) begin
                    hundreds_inc = bcd_inc(hundreds);
                    // Update thousands only if hundreds caused carry
                    if (hundreds_inc[4]) begin
                        thousands_inc = bcd_inc(thousands);
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