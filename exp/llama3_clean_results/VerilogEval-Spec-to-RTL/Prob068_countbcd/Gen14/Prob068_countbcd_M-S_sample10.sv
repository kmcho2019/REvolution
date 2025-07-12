module ParametricBCDCounter(
    input  clk,
    input  reset,
    output [15:0] q,
    output [2:0] ena
);

reg [3:0] ones, tens, hundreds, thousands;
reg [2:0] enable;

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        reg [3:0] new_ones, new_tens, new_hundreds, new_thousands;
        reg [2:0] new_enable;
        
        new_ones = ones + 1;
        if (new_ones == 4'd10) begin
            new_ones = 4'd0;
            new_tens = tens + 1;
        end else begin
            new_tens = tens;
        end
        
        if (new_tens == 4'd10) begin
            new_tens = 4'd0;
            new_hundreds = hundreds + 1;
        end else begin
            new_hundreds = hundreds;
        end
        
        if (new_hundreds == 4'd10) begin
            new_hundreds = 4'd0;
            new_thousands = thousands + 1;
        end else begin
            new_thousands = thousands;
        end
        
        ones <= new_ones;
        tens <= new_tens;
        hundreds <= new_hundreds;
        thousands <= new_thousands;
        
        new_enable[0] = (ones == 4'd9);
        new_enable[1] = (tens == 4'd9) && (ones == 4'd9);
        new_enable[2] = (hundreds == 4'd9) && (tens == 4'd9) && (ones == 4'd9);
        
        enable <= new_enable;
    end
end

assign q = {thousands, hundreds, tens, ones};
assign ena = enable;

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

ParametricBCDCounter counter(
    .clk(clk),
    .reset(reset),
    .q(q),
    .ena(ena)
);

endmodule