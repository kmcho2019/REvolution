module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    wire rollover_ones, rollover_tens, rollover_hundreds;

    // Ones digit
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
        end else begin
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
        end
    end
    assign rollover_ones = (ones == 4'd9);

    // Tens digit
    always @(posedge clk) begin
        if (reset) begin
            tens <= 4'd0;
        end else if (rollover_ones) begin
            tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
        end
    end
    assign rollover_tens = (tens == 4'd9) & rollover_ones;

    // Hundreds digit
    always @(posedge clk) begin
        if (reset) begin
            hundreds <= 4'd0;
        end else if (rollover_tens) begin
            hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
        end
    end
    assign rollover_hundreds = (hundreds == 4'd9) & rollover_tens;

    // Thousands digit
    always @(posedge clk) begin
        if (reset) begin
            thousands <= 4'd0;
        end else if (rollover_hundreds) begin
            thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
        end
    end

    // Output assignments
    assign ena = {rollover_hundreds, rollover_tens, rollover_ones};
    assign q = {thousands, hundreds, tens, ones};

endmodule