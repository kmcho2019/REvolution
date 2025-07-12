module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg en_tens, en_hundreds, en_thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            en_tens <= 1'b0;
            en_hundreds <= 1'b0;
            en_thousands <= 1'b0;
        end else begin
            // Ones digit (always counting)
            if (ones == 4'd9) begin
                ones <= 4'd0;
                en_tens <= 1'b1;
            end else begin
                ones <= ones + 4'd1;
                en_tens <= 1'b0;
            end

            // Tens digit (only when enabled)
            if (en_tens) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    en_hundreds <= 1'b1;
                end else begin
                    tens <= tens + 4'd1;
                    en_hundreds <= 1'b0;
                end
            end else begin
                en_hundreds <= 1'b0;
            end

            // Hundreds digit (only when enabled)
            if (en_hundreds) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    en_thousands <= 1'b1;
                end else begin
                    hundreds <= hundreds + 4'd1;
                    en_thousands <= 1'b0;
                end
            end else begin
                en_thousands <= 1'b0;
            end

            // Thousands digit (only when enabled)
            if (en_thousands) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};
    assign ena = {en_thousands, en_hundreds, en_tens};

endmodule