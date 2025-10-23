module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] q_ones;
    reg [3:0] q_tens;
    reg [3:0] q_hundreds;
    reg [3:0] q_thousands;

    assign q = {q_thousands, q_hundreds, q_tens, q_ones};

    always @(posedge clk) begin
        if (reset) begin
            q_ones <= 4'b0;
            q_tens <= 4'b0;
            q_hundreds <= 4'b0;
            q_thousands <= 4'b0;
            ena <= 3'b0;
        end else begin
            q_ones <= q_ones + 1'b1;
            ena <= 3'b0;

            if (q_ones == 4'b1001) begin // ones digit overflow
                q_ones <= 4'b0;
                q_tens <= q_tens + 1'b1;
                ena[0] <= 1'b1;
            end

            if (q_tens == 4'b1001) begin // tens digit overflow
                q_tens <= 4'b0;
                q_hundreds <= q_hundreds + 1'b1;
                ena[1] <= 1'b1;
            end

            if (q_hundreds == 4'b1001) begin // hundreds digit overflow
                q_hundreds <= 4'b0;
                q_thousands <= q_thousands + 1'b1;
                ena[2] <= 1'b1;
            end

            if (q_thousands == 4'b1001) begin // thousands digit overflow
                q_thousands <= 4'b0;
            end
        end
    end
endmodule