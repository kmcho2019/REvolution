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
assign ena_ones = ones == 4'd9;
assign ena_tens = (tens == 4'd9) && ena_ones;
assign ena_hundreds = (hundreds == 4'd9) && ena_tens;

// sequential logic for each digit
always @(posedge clk) begin
    if (reset) begin
        // reset to 0
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
    end else begin
        // count up
        if (ena_ones) begin
            ones <= 4'd0;
            if (ena_tens) begin
                tens <= 4'd0;
                if (ena_hundreds) begin
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