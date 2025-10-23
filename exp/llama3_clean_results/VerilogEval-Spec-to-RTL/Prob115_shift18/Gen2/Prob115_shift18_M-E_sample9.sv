module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

wire [63:0] shift_out;
wire [63:0] load_out;

// Barrel shifter
always @(posedge clk) begin
  case (amount)
    2'b00: shift_out <= {q_reg[62:0], 1'b0}; // shift left by 1 bit
    2'b01: shift_out <= {q_reg[55:0], 8'b0}; // shift left by 8 bits
    2'b10: shift_out <= {q_reg[63], q_reg[63:1]}; // shift right by 1 bit (arithmetic)
    2'b11: shift_out <= {q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63:8]}; // shift right by 8 bits (arithmetic)
    default: shift_out <= q_reg;
  endcase
end

// Load operation
always @(posedge clk) begin
  if (load) begin
    load_out <= data;
  end else begin
    load_out <= q_reg;
  end
end

// Final output
always @(posedge clk) begin
  if (ena) begin
    q_reg <= shift_out;
  end else if (load) begin
    q_reg <= load_out;
  end else begin
    q_reg <= q_reg;
  end
end

assign q = q_reg;

endmodule