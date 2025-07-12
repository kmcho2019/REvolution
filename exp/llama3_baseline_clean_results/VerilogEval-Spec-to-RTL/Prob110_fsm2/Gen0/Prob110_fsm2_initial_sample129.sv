module TopModule(
  input clk,
  input areset,
  input j,
  input k,
  output reg out
);

reg [1:0] state, next_state;

// Define the states
localparam [1:0] OFF = 2'b00;
localparam [1:0] ON = 2'b01;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
  if (areset) begin
    state <= OFF;
  end else begin
    state <= next_state;
  end
end

// Combinational logic for next state and output
always @(*) begin
  case (state)
    OFF: begin
      if (j) begin
        next_state = ON;
      end else begin
        next_state = OFF;
      end
    end
    ON: begin
      if (k) begin
        next_state = OFF;
      end else begin
        next_state = ON;
      end
    end
    default: begin
      next_state = OFF;
    end
  endcase
end

// Output logic
always @(*) begin
  case (state)
    OFF: out = 1'b0;
    ON: out = 1'b1;
    default: out = 1'b0;
  endcase
end

endmodule