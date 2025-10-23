module bcd_counter(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

wire [3:0] ones;
wire [3:0] tens;
wire [3:0] hundreds;
wire [3:0] thousands;

digit_module ones_digit(
    .clk(clk),
    .reset(reset),
    .ena_in(1'b0),
    .ena_out(ena[0]),
    .q(ones)
);

digit_module tens_digit(
    .clk(clk),
    .reset(reset),
    .ena_in(ena[0]),
    .ena_out(ena[1]),
    .q(tens)
);

digit_module hundreds_digit(
    .clk(clk),
    .reset(reset),
    .ena_in(ena[1]),
    .ena_out(ena[2]),
    .q(hundreds)
);

digit_module thousands_digit(
    .clk(clk),
    .reset(reset),
    .ena_in(ena[2]),
    .ena_out(),
    .q(thousands)
);

assign q = {thousands, hundreds, tens, ones};

endmodule

module digit_module(
    input clk,
    input reset,
    input ena_in,
    output ena_out,
    output [3:0] q
);

reg [3:0] counter;

initial begin
    counter = 4'd0;
end

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'd0;
    end else if (ena_in) begin
        if (counter == 4'd9) begin
            counter <= 4'd0;
            ena_out <= 1'b1;
        end else begin
            counter <= counter + 1'b1;
            ena_out <= 1'b0;
        end
    end else begin
        ena_out <= 1'b0;
    end
end

assign q = counter;

endmodule