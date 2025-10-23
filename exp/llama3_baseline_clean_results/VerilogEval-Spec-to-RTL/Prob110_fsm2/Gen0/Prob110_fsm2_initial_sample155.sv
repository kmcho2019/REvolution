module TopModule(
  input  clk,
  input  areset,
  input  j,
  input  k,
  output reg out
);

reg [1:0] current_state, next_state;

// Define states
localparam OFF = 2'b00;
localparam ON  = 2'b01;

// State transition logic
always @(*) begin
  case (current_state)
    OFF: next_state = (j) ? ON : OFF;
    ON:  next_state = (k) ? OFF : ON;
    default: next_state = OFF;
  endcase
end

// State register
always @(posedge clk or posedge areset) begin
  if (areset) begin
    current_state <= OFF;
    out <= 1'b0;
  end else begin
    current_state <= next_state;
    case (current_state)
      OFF: out <= 1'b0;
      ON:  out <= 1'b1;
      default: out <= 1'b0;
    endcase
  end
end

endmodule