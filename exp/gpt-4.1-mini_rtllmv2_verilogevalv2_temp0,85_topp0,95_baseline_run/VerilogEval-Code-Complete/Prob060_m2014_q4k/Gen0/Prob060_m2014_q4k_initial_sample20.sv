module TopModule (
  input clk,
  input resetn,
  input in,
  output out
);
  reg [3:0] shift_reg;

  always @(posedge clk) begin
    if (!resetn) begin
      shift_reg <= 4'b0000; // synchronous active-low reset
    end else begin
      shift_reg <= {shift_reg[2:0], in}; // shift left and insert in at LSB
    end
  end

  assign out = shift_reg[3]; // output from last flip-flop
endmodule