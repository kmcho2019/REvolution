module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

// State definitions
parameter OFF = 2'b00;
parameter ON = 2'b01;

// State and next state variables
reg [1:0] state, next_state;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= OFF;
  end else begin
    state <= next_state;
  end
end

// Output logic based on the current state
always @* begin
  case (state)
    OFF: out = 1'b0;
    ON: out = 1'b1;
  endcase
end

// State transition logic based on current state and inputs
always @* begin
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
  endcase
end

endmodule