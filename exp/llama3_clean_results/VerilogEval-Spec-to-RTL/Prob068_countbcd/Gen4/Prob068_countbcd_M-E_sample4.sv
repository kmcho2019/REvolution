module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg [2:0] ena_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena_reg <= 3'b000;
        end else begin
            reg [3:0] new_ones = ones;
            reg [3:0] new_tens = tens;
            reg [3:0] new_hundreds = hundreds;
            reg [3:0] new_thousands = thousands;
            reg [2:0] new_ena = 3'b000;

            // Ones digit
            new_ones <= ones + 1;
            if (ones == 4'd9) begin
                new_ones <= 4'd0;
                new_ena[0] <= 1'b1; // Enable tens digit
            end

            // Tens digit
            if (ena_reg[0] == 1'b1) begin
                new_tens <= tens + 1;
                if (tens == 4'd9) begin
                    new_tens <= 4'd0;
                    new_ena[1] <= 1'b1; // Enable hundreds digit
                end else begin
                    new_ena[0] <= 1'b0;
                end
            end

            // Hundreds digit
            if (ena_reg[1] == 1'b1) begin
                new_hundreds <= hundreds + 1;
                if (hundreds == 4'd9) begin
                    new_hundreds <= 4'd0;
                    new_ena[2] <= 1'b1; // Enable thousands digit
                end else begin
                    new_ena[1] <= 1'b0;
                end
            end

            // Thousands digit
            if (ena_reg[2] == 1'b1) begin
                new_thousands <= thousands + 1;
                if (thousands == 4'd9) begin
                    new_thousands <= 4'd0; // Wrap around
                    new_ena[2] <= 1'b0;
                end
            end

            ones <= new_ones;
            tens <= new_tens;
            hundreds <= new_hundreds;
            thousands <= new_thousands;
            ena_reg <= new_ena;
        end
    end

    assign q = {thousands, hundreds, tens, ones};
    assign ena = ena_reg;

endmodule