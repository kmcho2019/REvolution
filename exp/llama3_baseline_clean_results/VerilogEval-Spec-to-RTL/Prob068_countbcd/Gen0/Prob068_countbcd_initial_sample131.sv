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

    always @ (posedge clk) begin
        if (reset) begin
            q_ones <= 4'b0000;
            q_tens <= 4'b0000;
            q_hundreds <= 4'b0000;
            q_thousands <= 4'b0000;
            ena <= 3'b000;
        end else begin
            q_ones <= q_ones + 1;
            if (q_ones == 4'b1001) begin
                q_ones <= 4'b0000;
                q_tens <= q_tens + 1;
            end
            if (q_tens == 4'b1001) begin
                q_tens <= 4'b0000;
                q_hundreds <= q_hundreds + 1;
            end
            if (q_hundreds == 4'b1001) begin
                q_hundreds <= 4'b0000;
                q_thousands <= q_thousands + 1;
            end
            if (q_thousands == 4'b1001) begin
                q_thousands <= 4'b0000;
            end
            ena[0] <= (q_ones == 4'b1001)? 1'b1 : 1'b0;
            ena[1] <= (q_tens == 4'b1001)? 1'b1 : 1'b0;
            ena[2] <= (q_hundreds == 4'b1001)? 1'b1 : 1'b0;
        end
    end

endmodule