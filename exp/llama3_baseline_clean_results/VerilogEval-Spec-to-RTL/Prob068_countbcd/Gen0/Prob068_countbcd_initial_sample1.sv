module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;
reg [2:0] ena;

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 0;
        q_tens <= 0;
        q_hundreds <= 0;
        q_thousands <= 0;
        ena <= 0;
    end else begin
        // increment ones digit
        if (q_ones == 9) begin
            q_ones <= 0;
            ena[0] <= 1;
        end else begin
            q_ones <= q_ones + 1;
            ena[0] <= 0;
        end

        // increment tens digit
        if (q_ones == 0 && ena[0] == 1) begin
            if (q_tens == 9) begin
                q_tens <= 0;
                ena[1] <= 1;
            end else begin
                q_tens <= q_tens + 1;
                ena[1] <= 0;
            end
        end else begin
            ena[1] <= 0;
        end

        // increment hundreds digit
        if (q_tens == 0 && ena[1] == 1) begin
            if (q_hundreds == 9) begin
                q_hundreds <= 0;
                ena[2] <= 1;
            end else begin
                q_hundreds <= q_hundreds + 1;
                ena[2] <= 0;
            end
        end else begin
            ena[2] <= 0;
        end

        // increment thousands digit
        if (q_hundreds == 0 && ena[2] == 1) begin
            if (q_thousands == 9) begin
                q_thousands <= 0;
            end else begin
                q_thousands <= q_thousands + 1;
            end
        end
    end
end

assign q[3:0] = q_ones;
assign q[7:4] = q_tens;
assign q[11:8] = q_hundreds;
assign q[15:12] = q_thousands;

endmodule