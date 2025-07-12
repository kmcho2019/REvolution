module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg carry_ones, carry_tens, carry_hundreds;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
            ena       <= 3'b000;
            carry_ones    <= 1'b0;
            carry_tens    <= 1'b0;
            carry_hundreds= 1'b0;
        end else begin
            // Increment ones every cycle
            if (ones == 4'd9) begin
                ones <= 4'd0;
                carry_ones <= 1'b1;
            end else begin
                ones <= ones + 4'd1;
                carry_ones <= 1'b0;
            end

            // Increment tens if ena[0] is asserted
            if (ena[0]) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    carry_tens <= 1'b1;
                end else begin
                    tens <= tens + 4'd1;
                    carry_tens <= 1'b0;
                end
            end else begin
                // retain tens digit
                tens <= tens;
                carry_tens <= 1'b0;
            end

            // Increment hundreds if ena[1] is asserted
            if (ena[1]) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    carry_hundreds <= 1'b1;
                end else begin
                    hundreds <= hundreds + 4'd1;
                    carry_hundreds <= 1'b0;
                end
            end else begin
                hundreds <= hundreds;
                carry_hundreds <= 1'b0;
            end

            // Increment thousands if ena[2] is asserted
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                    // No further carry needed as this is the most significant digit
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end else begin
                thousands <= thousands;
            end

            // Update ena signals for next cycle based on carries this cycle
            ena[0] <= carry_ones;        // enable tens next cycle if ones carry
            ena[1] <= carry_tens;        // enable hundreds next cycle if tens carry
            ena[2] <= carry_hundreds;    // enable thousands next cycle if hundreds carry
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule