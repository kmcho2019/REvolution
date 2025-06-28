module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [3:0] q_ones = 4'b0000;
reg [3:0] q_tens = 4'b0000;
reg [3:0] q_hundreds = 4'b0000;
reg [3:0] q_thousands = 4'b0000;

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 4'b0000;
        q_tens <= 4'b0000;
        q_hundreds <= 4'b0000;
        q_thousands <= 4'b0000;
    end else begin
        // Increment ones digit on every clock cycle
        q_ones <= (q_ones == 4'b1001) ? 4'b0000 : q_ones + 1;
        
        // Increment tens digit if enable for tens is high
        if (ena[1] == 1)
            q_tens <= (q_tens == 4'b1001) ? 4'b0000 : q_tens + 1;
        
        // Increment hundreds digit if enable for hundreds is high
        if (ena[2] == 1)
            q_hundreds <= (q_hundreds == 4'b1001) ? 4'b0000 : q_hundreds + 1;
        
        // Increment thousands digit if enable for thousands is high
        if (ena[3] == 1)
            q_thousands <= (q_thousands == 4'b1001) ? 4'b0000 : q_thousands + 1;
    end
end

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

endmodule