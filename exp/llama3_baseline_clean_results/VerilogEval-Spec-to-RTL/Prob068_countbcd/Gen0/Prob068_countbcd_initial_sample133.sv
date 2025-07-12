module BCD_Counter(clk, reset, ena, q);
    input clk, reset, ena;
    output [3:0] q;

    reg [3:0] q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (ena) begin
            if (q == 4'b1001) begin
                q <= 4'b0000;
            end else begin
                q <= q + 1;
            end
        end
    end
endmodule

module TopModule(clk, reset, ena, q);
    input clk, reset;
    output [2:0] ena;
    output [15:0] q;

    wire [3:0] q_ones, q_tens, q_hundreds, q_thousands;
    reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;

    BCD_Counter ones_counter(clk, reset, 1'b1, q_ones);
    BCD_Counter tens_counter(clk, reset, q_ones[3], q_tens);
    BCD_Counter hundreds_counter(clk, reset, q_tens[3], q_hundreds);
    BCD_Counter thousands_counter(clk, reset, q_hundreds[3], q_thousands);

    assign ena[0] = q_ones[3];
    assign ena[1] = q_tens[3];
    assign ena[2] = q_hundreds[3];
    assign q = {q_thousands, q_hundreds, q_tens, q_ones};
endmodule