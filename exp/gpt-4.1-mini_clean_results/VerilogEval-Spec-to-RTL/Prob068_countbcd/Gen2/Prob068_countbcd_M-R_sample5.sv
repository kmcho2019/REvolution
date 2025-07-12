module TopModule (
    input  clk,
    input  reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg carry_ones, carry_tens, carry_hundreds;

    always @(posedge clk) begin
        if (reset) begin
            ones     <= 4'd0;
            tens     <= 4'd0;
            hundreds <= 4'd0;
            thousands<= 4'd0;
            ena      <= 3'b000;
            q        <= 16'd0;
            carry_ones   <= 1'b0;
            carry_tens   <= 1'b0;
            carry_hundreds <= 1'b0;
        end else begin
            // Use blocking assignments for carry propagation within the same cycle
            reg [3:0] ones_n, tens_n, hundreds_n, thousands_n;
            reg carry_ones_n, carry_tens_n, carry_hundreds_n;

            // Increment ones digit every clock
            if (ones == 4'd9) begin
                ones_n = 4'd0;
                carry_ones_n = 1'b1;
            end else begin
                ones_n = ones + 1;
                carry_ones_n = 1'b0;
            end

            // Increment tens digit if ones digit rolled over
            if (carry_ones_n) begin
                if (tens == 4'd9) begin
                    tens_n = 4'd0;
                    carry_tens_n = 1'b1;
                end else begin
                    tens_n = tens + 1;
                    carry_tens_n = 1'b0;
                end
            end else begin
                tens_n = tens;
                carry_tens_n = 1'b0;
            end

            // Increment hundreds digit if tens digit rolled over
            if (carry_tens_n) begin
                if (hundreds == 4'd9) begin
                    hundreds_n = 4'd0;
                    carry_hundreds_n = 1'b1;
                end else begin
                    hundreds_n = hundreds + 1;
                    carry_hundreds_n = 1'b0;
                end
            end else begin
                hundreds_n = hundreds;
                carry_hundreds_n = 1'b0;
            end

            // Increment thousands digit if hundreds digit rolled over
            if (carry_hundreds_n) begin
                if (thousands == 4'd9) begin
                    thousands_n = 4'd0;
                end else begin
                    thousands_n = thousands + 1;
                end
            end else begin
                thousands_n = thousands;
            end

            // Update registers
            ones     <= ones_n;
            tens     <= tens_n;
            hundreds <= hundreds_n;
            thousands<= thousands_n;
            carry_ones   <= carry_ones_n;
            carry_tens   <= carry_tens_n;
            carry_hundreds <= carry_hundreds_n;

            // ena signals reflect increments of upper digits
            ena[0] <= carry_ones_n;                  // tens increments
            ena[1] <= carry_tens_n;                  // hundreds increments
            ena[2] <= carry_hundreds_n;              // thousands increments

            // Concatenate digits into q
            q <= {thousands_n, hundreds_n, tens_n, ones_n};
        end
    end

endmodule