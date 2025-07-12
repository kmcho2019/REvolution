module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

// internal signals for each digit
reg [3:0] ones;
reg [3:0] tens;
reg [3:0] hundreds;
reg [3:0] thousands;

// internal enable signals
wire ena_ones;
wire ena_tens;
wire ena_hundreds;

// assign outputs
assign ena = {ena_hundreds, ena_tens, ena_ones};
assign q = {thousands, hundreds, tens, ones};

// enable signals
assign ena_ones = 1'b1; // always enable the ones place
assign ena_tens = (ones == 4'd9);
assign ena_hundreds = (tens == 4'd9);
assign ena[2] = (hundreds == 4'd9);

// sequential logic for each digit
always @(posedge clk) begin
    if (reset) begin
        // reset to 0
        ones <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
        thousands <= 4'd0;
    end else begin
        // count up
        if (ena_ones) begin
            if (ones == 4'd9) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 1;
            end
        end

        if (ena_tens) begin
            if (tens == 4'd9) begin
                tens <= 4'd0;
            end else begin
                tens <= tens + 1;
            end
        end

        if (ena_hundreds) begin
            if (hundreds == 4'd9) begin
                hundreds <= 4'd0;
            end else begin
                hundreds <= hundreds + 1;
            end
        end

        if (ena[2]) begin
            if (thousands == 4'd9) begin
                thousands <= 4'd0;
            end else begin
                thousands <= thousands + 1;
            end
        end
    end
end

endmodule