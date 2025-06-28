module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output reg [63:0] q
);
  
  always @(posedge clk) begin
    if (load) begin  // Load data instead of shifting
      q <= data;
    end else begin
      case(amount)
        2'b00: q <= ena ? {q[62:0], q[63]} : q; // Shift left by 1
        2'b01: q <= ena ? {q[55:0], 8'b0} : q;  // Shift left by 8
        2'b10: q <= ena ? {q[0], q[63:1]} : q;   // Shift right by 1
        2'b11: q <= ena ? {{8{q[63]}}, q[63:8]} : q;  // Shift right by 8
        default: q <= q;
      endcase
    end
  end
endmodule