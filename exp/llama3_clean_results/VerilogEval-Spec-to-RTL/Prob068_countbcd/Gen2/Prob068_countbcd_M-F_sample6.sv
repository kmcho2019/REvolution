module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;

// Calculate the next state of each digit
wire [3:0] q_ones_next = (q_ones == 4'b1001) ? 4'b0000 : q_ones + 1;
wire [3:0] q_tens_next = (q_ones == 4'b1001) ? (q_tens == 4'b1001) ? 4'b0000 : q_tens + 1 : q_tens;
wire [3:0] q_hundreds_next = (q_tens == 4'b1001 && q_ones == 4'b1001) ? (q_hundreds == 4'b1001) ? 4'b0000 : q_hundreds + 1 : q_hundreds;
wire [3:0] q_thousands_next = (q_hundreds == 4'b1001 && q_tens == 4'b1001 && q_ones == 4'b1001) ? (q_thousands == 4'b1001) ? 4'b0000 : q_thousands + 1 : q_thousands;

// Calculate the enable signals for each digit
wire ena_ones = (q_ones == 4'b1001);
wire ena_tens = (q_tens == 4'b1001 && q_ones == 4'b1001);
wire ena_hundreds = (q_hundreds == 4'b1001 && q_tens == 4'b1001 && q_ones == 4'b1001);

// Update the current state of the digits
always @(posedge clk) begin
    if (reset) begin
        q_ones <= 4'b0000;
        q_tens <= 4'b0000;
        q_hundreds <= 4'b0000;
        q_thousands <= 4'b0000;
    end else begin
        q_ones <= q_ones_next;
        q_tens <= q_tens_next;
        q_hundreds <= q_hundreds_next;
        q_thousands <= q_thousands_next;
    end
end

// Connect the output ports to the current state of the digits and the enable signals
assign ena = {ena_hundreds, ena_tens, ena_ones};
assign q = {q_thousands, q_hundreds, q_tens, q_ones};

endmodule