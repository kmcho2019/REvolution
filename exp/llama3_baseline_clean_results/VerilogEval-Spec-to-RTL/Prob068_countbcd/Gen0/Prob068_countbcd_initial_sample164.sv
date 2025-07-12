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

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 0;
        q_tens <= 0;
        q_hundreds <= 0;
        q_thousands <= 0;
    end else begin
        // Ones digit
        if (q_ones == 9) begin
            q_ones <= 0;
            ena[0] <= 1'b1;
        end else begin
            q_ones <= q_ones + 1;
            ena[0] <= 1'b0;
        end

        // Tens digit
        if (ena[0] && q_tens == 9) begin
            q_tens <= 0;
            ena[1] <= 1'b1;
        end else if (ena[0]) begin
            q_tens <= q_tens + 1;
            ena[1] <= 1'b0;
        end else begin
            ena[1] <= 1'b0;
        end

        // Hundreds digit
        if (ena[1] && q_hundreds == 9) begin
            q_hundreds <= 0;
            ena[2] <= 1'b1;
        end else if (ena[1]) begin
            q_hundreds <= q_hundreds + 1;
            ena[2] <= 1'b0;
        end else begin
            ena[2] <= 1'b0;
        end

        // Thousands digit
        if (ena[2] && q_thousands == 9) begin
            q_thousands <= 0;
        end else if (ena[2]) begin
            q_thousands <= q_thousands + 1;
        end
    end
end

assign q[3:0] = q_ones;
assign q[7:4] = q_tens;
assign q[11:8] = q_hundreds;
assign q[15:12] = q_thousands;

endmodule