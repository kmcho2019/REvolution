module TopModule (
  input clk,
  input enable,
  input S,
  input A,
  input B,
  input C,
  output reg Z
);

  reg [7:0] memory [0:7];
  reg [7:0] shift_register;

  always @(posedge clk) begin
    if (enable) begin
      // Shift in data
      shift_register <= {shift_register[6:0], S};

      // Write data to memory
      memory[0] <= shift_register;
    end
  end

  always @* begin
    // Output selection based on A, B, C
    case({A, B, C})
      3'b000: Z = memory[0][7];
      3'b001: Z = memory[1][7];
      3'b010: Z = memory[2][7];
      3'b011: Z = memory[3][7];
      3'b100: Z = memory[4][7];
      3'b101: Z = memory[5][7];
      3'b110: Z = memory[6][7];
      3'b111: Z = memory[7][7];
    endcase
  end

endmodule