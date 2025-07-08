module TopModule (
  input clk,
  input enable,
  input S,
  input A,
  input B,
  input C,
  output reg Z
);

  reg [7:0] Q;

  // 8-bit shift register with synchronous enable and shift-in input S
  always @(posedge clk) begin
    if (enable) begin
      Q <= {Q[6:0], S};  // Shift left: Q[0] gets Q[1], ..., Q[6] gets Q[7], Q[7] gets S (MSB shifted in first)
    end
  end

  // Multiplexer to select Q[i] based on ABC as index
  always @(*) begin
    case ({A,B,C})
      3'b000: Z = Q[0];
      3'b001: Z = Q[1];
      3'b010: Z = Q[2];
      3'b011: Z = Q[3];
      3'b100: Z = Q[4];
      3'b101: Z = Q[5];
      3'b110: Z = Q[6];
      3'b111: Z = Q[7];
      default: Z = 1'b0; // should never occur
    endcase
  end

endmodule