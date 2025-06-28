module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  reg [511:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load data when load is active
    end else begin
      // Temporary variable to store the updated cell states
      reg [511:0] temp_q;

      // Implement Rule 110 for each cell using a for loop
      for (int i = 0; i < 512; i = i + 1) begin
        // Define the boundaries where the two adjacent cell states are 0
        int left = (i == 0) ? 0 : q[i-1];
        int right = (i == 511) ? 0 : q[i+1];

        // Implement Rule 110 for the current cell
        case ({left, q[i], right})
          3'b111: temp_q[i] = 1'b0;
          3'b110: temp_q[i] = 1'b1;
          3'b101: temp_q[i] = 1'b1;
          3'b100: temp_q[i] = 1'b0;
          3'b011: temp_q[i] = 1'b1;
          3'b010: temp_q[i] = 1'b1;
          3'b001: temp_q[i] = 1'b1;
          3'b000: temp_q[i] = 1'b0;
        endcase
      end

      // Update all cell states synchronously
      next_q <= temp_q;
      q <= next_q;
    end
  end

endmodule