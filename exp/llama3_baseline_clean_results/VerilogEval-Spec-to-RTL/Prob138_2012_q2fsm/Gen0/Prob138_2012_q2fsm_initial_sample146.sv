module TopModule(clk, reset, w, z);
  input clk;
  input reset;
  input w;
  output z;
  reg [2:0] state, next_state;

  // State table
  always @(*) begin
    case (state)
      3'b000: next_state = w ? 3'b001 : 3'b000;
      3'b001: next_state = w ? 3'b010 : 3'b011;
      3'b010: next_state = w ? 3'b100 : 3'b011;
      3'b011: next_state = w ? 3'b101 : 3'b000;
      3'b100: next_state = w ? 3'b100 : 3'b011;
      3'b101: next_state = w ? 3'b010 : 3'b011;
      default: next_state = 3'b000;
    endcase
  end

  // State flip-flops
  always @(posedge clk) begin
    if (reset) begin
      state <= 3'b000;
    end else begin
      state <= next_state;
    end
  end

  // Output
  assign z = (state == 3'b100) || (state == 3'b101);

endmodule