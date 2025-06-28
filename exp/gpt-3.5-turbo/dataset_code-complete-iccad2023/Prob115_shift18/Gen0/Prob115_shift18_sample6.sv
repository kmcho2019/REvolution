module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output reg [63:0] q
);

  // Temporary storage for shifted/loaded data
  reg [63:0] temp_q;
  
  always @(posedge clk) begin
    if (load) begin
      temp_q <= data;
    end else begin
      case (amount)
        2'b00: temp_q <= ena ? {temp_q[62:0], temp_q[63]} : temp_q;
        2'b01: temp_q <= ena ? {temp_q[55:0], temp_q[63:56]} : temp_q;
        2'b10: temp_q <= ena ? {temp_q[0], temp_q[63:1]} : temp_q;
        2'b11: temp_q <= ena ? {temp_q[7:0], temp_q[63:8]} : temp_q;
      endcase
    end
  end

  // Output q
  always @* begin
    q = temp_q;
  end

endmodule