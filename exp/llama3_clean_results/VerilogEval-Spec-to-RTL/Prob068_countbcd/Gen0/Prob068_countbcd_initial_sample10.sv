module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    wire en_ones, en_tens, en_hundreds;

    assign en_ones = (ones == 4'd9) ? 1'b1 : 1'b0;
    assign en_tens = (tens == 4'd9) && en_ones ? 1'b1 : 1'b0;
    assign en_hundreds = (hundreds == 4'd9) && en_tens ? 1'b1 : 1'b0;

    assign ena = {en_hundreds, en_tens, en_ones};

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            if (en_ones) begin
                ones <= ones + 1;
                if (ones == 4'd10) ones <= 4'd0;
            end
            if (en_tens) begin
                tens <= tens + 1;
                if (tens == 4'd10) tens <= 4'd0;
            end
            if (en_hundreds) begin
                hundreds <= hundreds + 1;
                if (hundreds == 4'd10) hundreds <= 4'd0;
            end
            if (en_hundreds && en_tens && en_ones) begin
                thousands <= thousands + 1;
                if (thousands == 4'd10) thousands <= 4'd0;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule