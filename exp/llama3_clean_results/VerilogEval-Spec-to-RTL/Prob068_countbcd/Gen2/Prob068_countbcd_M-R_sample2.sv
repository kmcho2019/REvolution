module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;

// Calculate the enable signals for each digit
assign ena[0] = (q_ones == 4'b1001);
assign ena[1] = (q_tens == 4'b1001 && q_ones == 4'b1001);
assign ena[2] = (q_hundreds == 4'b1001 && q_tens == 4'b1001 && q_ones == 4'b1001);

// Calculate the next state of each digit
always @(posedge clk) begin
    if (reset) begin
        q_ones <= 4'b0000;
        q_tens <= 4'b0000;
        q_hundreds <= 4'b0000;
        q_thousands <= 4'b0000;
    end else begin
        if (ena[0]) begin
            q_ones <= 4'b0000;
            if (ena[1]) begin
                q_tens <= 4'b0000;
                if (ena[2]) begin
                    q_thousands <= q_thousands + 1;
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

// Connect the output ports to the current state of the digits
assign q = {q_thousands, q_hundreds, q_tens, q_ones};

endmodule