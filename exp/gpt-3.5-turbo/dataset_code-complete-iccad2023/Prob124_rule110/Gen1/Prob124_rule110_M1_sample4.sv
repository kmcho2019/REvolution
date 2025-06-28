module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  reg [511:0] new_q; // Register to store the new states of all cells

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load data if load signal is high
    end else begin
      // Assign the new states of each cell based on Rule 110
      // Handle boundary condition assumption where q[-1] and q[512] are always 0
      new_q[0] = 0;
      new_q[511] = 0;
      for (int i = 1; i < 511; i = i + 1) begin
        case({q[i-1], q[i], q[i+1]})
          3'b111: new_q[i] = 1'b0;
          3'b110: new_q[i] = 1'b1;
          3'b101: new_q[i] = 1'b1;
          3'b100: new_q[i] = 1'b0;
          3'b011: new_q[i] = 1'b1;
          3'b010: new_q[i] = 1'b1;
          3'b001: new_q[i] = 1'b1;
          3'b000: new_q[i] = 1'b0;
        endcase
      end
      // Update all cell states concurrently after computing new states
      q <= new_q;
    end
  end

endmodule