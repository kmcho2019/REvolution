module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones     <= 4'd0;
            tens     <= 4'd0;
            hundreds <= 4'd0;
            thousands<= 4'd0;
            ena      <= 3'b000;
            q        <= 16'd0;
        end else begin
            reg [3:0] ones_n, tens_n, hundreds_n, thousands_n;
            reg [2:0] ena_n;

            // Increment ones digit every clock
            if (ones == 4'd9) begin
                ones_n = 4'd0;
            end else begin
                ones_n = ones + 1;
            end

            // Increment tens digit if ones rolled over
            if (ones == 4'd9) begin
                if (tens == 4'd9) begin
                    tens_n = 4'd0;
                end else begin
                    tens_n = tens + 1;
                end
            end else begin
                tens_n = tens;
            end

            // Increment hundreds digit if tens rolled over
            if (tens == 4'd9 && ones == 4'd9) begin
                if (hundreds == 4'd9) begin
                    hundreds_n = 4'd0;
                end else begin
                    hundreds_n = hundreds + 1;
                end
            end else begin
                hundreds_n = hundreds;
            end

            // Increment thousands digit if hundreds rolled over
            if (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9) begin
                if (thousands == 4'd9) begin
                    thousands_n = 4'd0;
                end else begin
                    thousands_n = thousands + 1;
                end
            end else begin
                thousands_n = thousands;
            end

            // Compute ena signals:
            // ena[i] is high when digit i+1 increments (tens=ena[0], hundreds=ena[1], thousands=ena[2])
            // A digit increments if next value != current and current != 9 (i.e. increment, not rollover)
            ena_n[0] = (tens_n != tens) && (tens != 4'd9);
            ena_n[1] = (hundreds_n != hundreds) && (hundreds != 4'd9);
            ena_n[2] = (thousands_n != thousands) && (thousands != 4'd9);

            // Update registers
            ones      <= ones_n;
            tens      <= tens_n;
            hundreds  <= hundreds_n;
            thousands <= thousands_n;
            ena       <= ena_n;

            // Concatenate digits into q
            q <= {thousands_n, hundreds_n, tens_n, ones_n};
        end
    end

endmodule