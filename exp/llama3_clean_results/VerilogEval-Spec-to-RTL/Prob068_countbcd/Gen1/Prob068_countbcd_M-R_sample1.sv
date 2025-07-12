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

// assign outputs
assign q = {thousands, hundreds, tens, ones};

// enable signals
wire wrap_ones;
wire wrap_tens;
wire wrap_hundreds;

assign wrap_ones = (ones == 4'd9);
assign wrap_tens = (tens == 4'd9) && wrap_ones;
assign wrap_hundreds = (hundreds == 4'd9) && wrap_tens;

assign ena = {wrap_hundreds, wrap_tens, wrap_ones};

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
        if (wrap_ones) begin
            ones <= 4'd0;
            if (wrap_tens) begin
                tens <= 4'd0;
                if (wrap_hundreds) begin
                    hundreds <= 4'd0;
                    thousands <= thousands + 1;
                end else begin
                    hundreds <= hundreds + 1;
                end
            end else begin
                tens <= tens + 1;
            end
        end else begin
            ones <= ones + 1;
        end
    end
end

endmodule