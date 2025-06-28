module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      reg [511:0] next_q;

      // Handle boundary conditions
      next_q[0] = ((q[1] & q[0]) | (q[1] ^ q[0])) ^ q[0];
      next_q[511] = ((q[510] & q[511]) | (q[510] ^ q[511])) ^ q[511];

      // Calculate next state for internal cells based on Rule 110
      integer i;
      for (i = 1; i < 511; i = i + 1) begin
        case({q[i+1], q[i], q[i-1]})
          3'b111: next_q[i] = 1'b0;
          3'b110: next_q[i] = 1'b1;
          3'b101: next_q[i] = 1'b1;
          3'b100: next_q[i] = 1'b0;
          3'b011: next_q[i] = 1'b1;
          3'b010: next_q[i] = 1'b1;
          3'b001: next_q[i] = 1'b1;
          3'b000: next_q[i] = 1'b0;
        endcase
      end

      q <= next_q;
    end
  end

endmodule