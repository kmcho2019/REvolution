module TopModule (
  input clk,
  input reset,
  input [3:1] ena,
  output reg [15:0] q
);

reg [3:0] q_ones = 4'b0000;
reg [3:0] q_tens = 4'b0000;
reg [3:0] q_hundreds = 4'b0000;
reg [3:0] q_thousands = 4'b0000;

reg [3:0] q_tens_next, q_hundreds_next, q_thousands_next; // Next state variables for tens, hundreds, and thousands digits

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 4'b0000;
        q_tens <= 4'b0000;
        q_hundreds <= 4'b0000;
        q_thousands <= 4'b0000;
    end else begin
        // Increment ones digit on every clock cycle
        q_ones <= (q_ones == 4'b1001) ? 4'b0000 : q_ones + 1;
        
        // Enable logic for tens digit
        q_tens_next = (ena[1] == 1) ? ((q_tens == 4'b1001) ? 4'b0000 : q_tens + 1) : q_tens;
        
        // Enable logic for hundreds digit
        q_hundreds_next = (ena[2] == 1) ? ((q_hundreds == 4'b1001) ? 4'b0000 : q_hundreds + 1) : q_hundreds;
        
        // Enable logic for thousands digit
        q_thousands_next = (ena[3] == 1) ? ((q_thousands == 4'b1001) ? 4'b0000 : q_thousands + 1) : q_thousands;
    end
end

always @* begin
    q_tens <= q_tens_next;
    q_hundreds <= q_hundreds_next;
    q_thousands <= q_thousands_next;
end

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

endmodule