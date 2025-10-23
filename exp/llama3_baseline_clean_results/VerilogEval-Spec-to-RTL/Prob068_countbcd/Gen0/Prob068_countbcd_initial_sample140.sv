module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

assign ena = {thousands_en, hundreds_en, tens_en};
assign q = {thousands, hundreds, tens, ones};

wire ones_en = 1'b1;
wire tens_en = ones == 4'd9;
wire hundreds_en = tens == 4'd9 && ones_en;
wire thousands_en = hundreds == 4'd9 && tens_en;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        if (ones_en) begin
            if (ones == 4'd9) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 1;
            end
        end
        if (tens_en) begin
            if (tens == 4'd9) begin
                tens <= 4'd0;
            end else begin
                tens <= tens + 1;
            end
        end
        if (hundreds_en) begin
            if (hundreds == 4'd9) begin
                hundreds <= 4'd0;
            end else begin
                hundreds <= hundreds + 1;
            end
        end
        if (thousands_en) begin
            if (thousands == 4'd9) begin
                thousands <= 4'd0;
            end else begin
                thousands <= thousands + 1;
            end
        end
    end
end

endmodule