module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  reg [511:0] q_buffer; // Buffer for current cell states
  integer i;

  // Buffer the current cell states on each clock cycle
  always @(posedge clk) begin
    if (load) begin
      q_buffer <= data;
    end
  end

  // Update all cell states synchronously based on Rule 110 logic
  always @(*) begin
    for (i=0; i<512; i=i+1) begin
      int left = (i == 0) ? 0 : q_buffer[i-1];
      int right = (i == 511) ? 0 : q_buffer[i+1];

      case({left, q_buffer[i], right})
        3'b111: q[i] = 0;
        3'b110: q[i] = 1;
        3'b101: q[i] = 1;
        3'b100: q[i] = 0;
        3'b011: q[i] = 1;
        3'b010: q[i] = 1;
        3'b001: q[i] = 1;
        3'b000: q[i] = 0;
      endcase
    end
  end

endmodule