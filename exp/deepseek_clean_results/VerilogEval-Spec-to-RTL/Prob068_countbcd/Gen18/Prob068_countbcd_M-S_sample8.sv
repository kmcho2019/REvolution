module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit always increments
            if (ones == 4'd9) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end

            // Tens digit increments when ones rolls over
            if (ones == 4'd9) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end

            // Hundreds digit increments when tens rolls over
            if (ones == 4'd9 && tens == 4'd9) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end

            // Thousands digit increments when hundreds rolls over
            if (ones == 4'd9 && tens == 4'd9 && hundreds == 4'd9) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

    // Generate enable signals
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (ones == 4'd9) && (tens == 4'd9);
    assign ena[2] = (ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9);

    // Concatenate output
    assign q = {thousands, hundreds, tens, ones};

endmodule