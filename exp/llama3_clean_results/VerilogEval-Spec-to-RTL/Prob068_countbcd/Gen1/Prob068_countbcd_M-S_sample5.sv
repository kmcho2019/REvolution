module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg [2:0] ena_int;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            reg carry_ones = 1'b0;
            reg carry_tens = 1'b0;
            reg carry_hundreds = 1'b0;

            // Increment ones digit
            if (ones == 4'd9) begin
                ones <= 4'd0;
                carry_ones = 1'b1;
            end else begin
                ones <= ones + 1;
            end

            // Increment tens digit
            if (carry_ones && tens == 4'd9) begin
                tens <= 4'd0;
                carry_tens = 1'b1;
            end else if (carry_ones) begin
                tens <= tens + 1;
            end

            // Increment hundreds digit
            if (carry_tens && hundreds == 4'd9) begin
                hundreds <= 4'd0;
                carry_hundreds = 1'b1;
            end else if (carry_tens) begin
                hundreds <= hundreds + 1;
            end

            // Increment thousands digit
            if (carry_hundreds && thousands == 4'd9) begin
                thousands <= 4'd0;
            end else if (carry_hundreds) begin
                thousands <= thousands + 1;
            end
        end
    end

    // Generate enable signals
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9 && ones == 4'd9);
    assign ena[2] = (hundreds == 4'd9 && tens == 4'd9 && ones == 4'd9);

    // Assign outputs
    assign q = {thousands, hundreds, tens, ones};

endmodule