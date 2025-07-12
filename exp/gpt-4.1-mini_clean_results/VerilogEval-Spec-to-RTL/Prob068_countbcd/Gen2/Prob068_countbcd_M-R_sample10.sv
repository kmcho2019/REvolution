module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0]: ones, digits[1]: tens, digits[2]: hundreds, digits[3]: thousands

    // Combinational carries indicating when a digit will wrap from 9 to 0 on increment
    wire carry0_to_1, carry1_to_2, carry2_to_3;

    // Increment enables for each digit: ones always increments, others enabled by carry from previous digit
    wire inc_ones = 1'b1;
    wire inc_tens, inc_hundreds, inc_thousands;

    // Compute carry-out for ones digit
    assign carry0_to_1 = (digits[0] == 4'd9) && inc_ones;

    // For upper digits, enable increment if previous digit carries
    assign inc_tens = carry0_to_1;
    assign carry1_to_2 = (digits[1] == 4'd9) && inc_tens;

    assign inc_hundreds = carry1_to_2;
    assign carry2_to_3 = (digits[2] == 4'd9) && inc_hundreds;

    assign inc_thousands = carry2_to_3;

    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
            ena <= 3'b000;
            q <= 16'd0;
        end else begin
            // Update ones digit
            if (inc_ones) begin
                if (digits[0] == 4'd9)
                    digits[0] <= 4'd0;
                else
                    digits[0] <= digits[0] + 4'd1;
            end

            // Update tens digit
            if (inc_tens) begin
                if (digits[1] == 4'd9)
                    digits[1] <= 4'd0;
                else
                    digits[1] <= digits[1] + 4'd1;
            end

            // Update hundreds digit
            if (inc_hundreds) begin
                if (digits[2] == 4'd9)
                    digits[2] <= 4'd0;
                else
                    digits[2] <= digits[2] + 4'd1;
            end

            // Update thousands digit
            if (inc_thousands) begin
                if (digits[3] == 4'd9)
                    digits[3] <= 4'd0;
                else
                    digits[3] <= digits[3] + 4'd1;
            end

            // ena signals indicate when upper digits increment
            ena <= {inc_thousands, inc_hundreds, inc_tens};

            // Concatenate digits into output q
            q <= {digits[3], digits[2], digits[1], digits[0]};
        end
    end

endmodule