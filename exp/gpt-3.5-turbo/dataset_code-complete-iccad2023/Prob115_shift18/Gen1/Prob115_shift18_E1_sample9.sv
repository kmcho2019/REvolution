module ShiftRegister (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output reg [63:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else if (ena) begin
      case (amount)
        2'b00: q <= {q[62:0], q[63]}; // Shift left by 1 bit
        2'b01: q <= {q[55:0], q[63:56]}; // Shift left by 8 bits
        2'b10: begin
          // Arithmetic right shift by 1 bit
          q[0] <= q[63];
          q[63:1] <= q[63:1];
        end
        2'b11: begin
          // Arithmetic right shift by 8 bits
          q[0:7] <= {8{q[63]}};
          q[63:8] <= q[63:8];
        end
        default: q <= q; // No shift
      endcase
    end
  end

endmodule