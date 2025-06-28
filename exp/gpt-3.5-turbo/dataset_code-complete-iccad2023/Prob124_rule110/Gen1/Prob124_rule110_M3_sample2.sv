module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @(posedge clk) begin
    if (load)
      q <= data; // Load data when load is active
    else begin
      // Apply Rule 110 for each cell except boundaries
      for (int i = 0; i < 512; i = i + 1) begin
        int left = (i == 0) ? 0 : q[i-1];
        int right = (i == 511) ? 0 : q[i+1];
        
        // Implement Rule 110 logic
        case({left, q[i], right})
          3'b111: q[i] <= 1'b0;
          3'b110: q[i] <= 1'b1;
          3'b101: q[i] <= 1'b1;
          3'b100: q[i] <= 1'b0;
          3'b011: q[i] <= 1'b1;
          3'b010: q[i] <= 1'b1;
          3'b001: q[i] <= 1'b1;
          3'b000: q[i] <= 1'b0;
        endcase
      end
    end
  end

endmodule