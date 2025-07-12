module TopModule(
  input  clk,
  input  areset,
  input  x,
  output z
);

// Define states in one-hot encoding
reg [1:0] state;
wire [1:0] next_state;

// Define state encoding
localparam STATE_A = 2'b10;
localparam STATE_B = 2'b01;

// Combinational logic for next state and output
always @(*) begin
  case(state)
    STATE_A: begin
      if (~x) begin
        next_state = STATE_A;
        z = 1'b0;
      end else begin
        next_state = STATE_B;
        z = 1'b1;
      end
    end
    STATE_B: begin
      next_state = STATE_B;
      z = ~x;
    end
    default: begin
      next_state = STATE_A;
      z = 1'b0;
    end
  endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= STATE_A;
  end else begin
    state <= next_state;
  end
end

endmodule