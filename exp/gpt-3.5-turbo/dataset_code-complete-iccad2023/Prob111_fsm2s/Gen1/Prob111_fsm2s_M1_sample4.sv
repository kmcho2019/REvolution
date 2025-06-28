module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

// Define states
localparam OFF = 2'b00;
localparam ON = 2'b01;

// State register
reg [1:0] state, next_state;

always @(posedge clk) begin
  if (reset) begin
    state <= OFF;
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  case(state)
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
  endcase
end

// Output logic
always @(*) begin
  case(state)
    OFF: out = 1'b0;
    ON: out = 1'b1;
  endcase
end

endmodule