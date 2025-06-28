module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  reg [511:0] next_q; // Next state of the cells

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load data when load is active
    end else begin
      // Initialize boundary cells
      next_q[0] = (q[1]) ? 1 : 0;
      next_q[511] = (q[510]) ? 1 : 0;

      // Update states for internal cells based on Rule 110
      for (int i = 1; i < 511; i = i + 1) begin
        int left = q[i-1];
        int right = q[i+1];

        case({left, q[i], right})
          3'b111: next_q[i] = 0;
          3'b110: next_q[i] = 1;
          3'b101: next_q[i] = 1;
          3'b100: next_q[i] = 1;
          3'b011: next_q[i] = 1;
          3'b010: next_q[i] = 1;
          3'b001: next_q[i] = 1;
          3'b000: next_q[i] = 0;
        endcase
      end

      // Update current state with the next state
      q <= next_q;
    end
  end

endmodule