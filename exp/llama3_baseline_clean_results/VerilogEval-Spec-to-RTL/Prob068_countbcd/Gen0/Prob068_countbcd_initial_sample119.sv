module TopModule(
    input clk,
    input reset,
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
        ena <= 3'b000;
    end else begin
        ena <= 3'b000;
        if (q_ones == 9) begin
            ena[0] <= 1;
            q_ones <= 0;
            if (q_tens == 9) begin
                ena[1] <= 1;
                q_tens <= 0;
                if (q_hundreds == 9) begin
                    ena[2] <= 1;
                    q_hundreds <= 0;
                    if (q_thousands == 9) begin
                        q_thousands <= 0;
                    end else begin
                        q_thousands <= q_thousands + 1;
                    end
                end else begin
                    q_hundreds <= q_hundreds + 1;
                end
            end else begin
                q_tens <= q_tens + 1;
            end
        end else begin
            q_ones <= q_ones + 1;
        end
    end
end

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

endmodule