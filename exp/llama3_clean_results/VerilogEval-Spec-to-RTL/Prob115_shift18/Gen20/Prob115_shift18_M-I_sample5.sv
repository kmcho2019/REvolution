module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

// Control unit to determine shift operation
wire shift_left;
wire [1:0] shift_amount;
assign shift_left = (amount == 2'b00 || amount == 2'b01);
assign shift_amount = amount;

// Shift logic
wire [63:0] shifted_q;
assign shifted_q = (shift_left) ? 
                    (shift_amount == 2'b00) ? (q_reg << 1) : (q_reg << 8) : 
                    (shift_amount == 2'b10) ? ({q_reg[63], q_reg[63:1]}) : 
                    ({8{q_reg[63]}, q_reg[63:8]});

// Sequential logic
always @(posedge clk) begin
  if (load) begin
    q_reg <= data;
  end else if (ena) begin
    q_reg <= shifted_q;
  end
end

assign q = q_reg;

endmodule