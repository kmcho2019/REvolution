module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;
reg [2:0] ena_int;

// Calculate the next state of each digit
wire [3:0] q_ones_next = (q_ones == 4'b1001) ? 4'b0000 : q_ones + 1;
wire [3:0] q_tens_next = (ena_int[0] && q_tens == 4'b1001) ? 4'b0000 : (ena_int[0] ? q_tens + 1 : q_tens);
wire [3:0] q_hundreds_next = (ena_int[1] && q_hundreds == 4'b1001) ? 4'b0000 : (ena_int[1] ? q_hundreds + 1 : q_hundreds);
wire [3:0] q_thousands_next = (ena_int[2] && q_thousands == 4'b1001) ? 4'b0000 : (ena_int[2] ? q_thousands + 1 : q_thousands);

// Calculate the enable signals for each digit
wire ena_ones = (q_ones == 4'b1001);
wire ena_tens = (ena_int[0] && q_tens == 4'b1001);
wire ena_hundreds = (ena_int[1] && q_hundreds == 4'b1001);

// Update the current state of the digits
always @(posedge clk) begin
    if (reset) begin
        q_ones <= 4'b0000;
        q_tens <= 4'b0000;
        q_hundreds <= 4'b0000;
        q_thousands <= 4'b0000;
        ena_int <= 3'b000;
    end else begin
        q_ones <= q_ones_next;
        q_tens <= q_tens_next;
        q_hundreds <= q_hundreds_next;
        q_thousands <= q_thousands_next;
        ena_int[0] <= ena_ones;
        ena_int[1] <= ena_tens;
        ena_int[2] <= ena_hundreds;
    end
end

// Connect the output ports to the current state of the digits and the enable signals
assign ena = ena_int;
assign q = {q_thousands, q_hundreds, q_tens, q_ones};

endmodule