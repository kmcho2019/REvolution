module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digit0, digit1, digit2, digit3; // Ones, Tens, Hundreds, Thousands

    // Enable signals: indicate when each upper digit should increment (next digit increments if current digit is 9)
    assign ena[0] = (digit0 == 4'd9);
    assign ena[1] = ena[0] && (digit1 == 4'd9);
    assign ena[2] = ena[1] && (digit2 == 4'd9);

    // Pack digits into 16-bit output
    assign q = {digit3, digit2, digit1, digit0};

    // Function to increment a BCD digit with carry output
    function [4:0] bcd_increment;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_increment = {1'b1, 4'd0}; // carry out, reset digit
            else
                bcd_increment = {1'b0, digit + 4'd1};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
        end else begin
            // Increment ones digit first
            reg [4:0] inc0, inc1, inc2, inc3;

            inc0 = bcd_increment(digit0);
            digit0 <= inc0[3:0];

            // Propagate carry from ones digit
            if (inc0[4]) begin
                inc1 = bcd_increment(digit1);
                digit1 <= inc1[3:0];

                if (inc1[4]) begin
                    inc2 = bcd_increment(digit2);
                    digit2 <= inc2[3:0];

                    if (inc2[4]) begin
                        inc3 = bcd_increment(digit3);
                        digit3 <= inc3[3:0];
                    end else begin
                        digit3 <= digit3;
                    end
                end else begin
                    digit2 <= digit2;
                    digit3 <= digit3;
                end
            end else begin
                digit1 <= digit1;
                digit2 <= digit2;
                digit3 <= digit3;
            end
        end
    end

endmodule