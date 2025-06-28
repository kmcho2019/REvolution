module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @ (posedge clk) begin
    if (load)
      q <= data;
    else begin
      reg [511:0] next_q;

      // Update cell states based on Rule 110 logic
      for (int i = 0; i < 512; i = i + 1) begin
        int left = (i == 0) ? 1'b0 : q[i - 1];
        int right = (i == 511) ? 1'b0 : q[i + 1];

        case({left, q[i], right})
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

      q <= next_q; // Update cell states at the end of the cycle
    end
  end

endmodule