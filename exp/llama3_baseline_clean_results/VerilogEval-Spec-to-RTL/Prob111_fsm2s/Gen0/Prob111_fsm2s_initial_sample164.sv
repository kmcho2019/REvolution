module TopModule(
  input clk,
  input reset,
  input j,
  input k,
  output out
);

reg [1:0] state; // state variable
reg [1:0] next_state; // next state variable
reg out_reg; // output register

// state encoding
parameter OFF = 2'b00;
parameter ON = 2'b01;

// combinational logic for next state and output
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
    default: next_state = OFF;
  endcase

  // Moore machine output only depends on current state
  case(state)
    OFF: out_reg = 1'b0;
    ON: out_reg = 1'b1;
    default: out_reg = 1'b0;
  endcase
end

// sequential logic for state and output registers
always @(posedge clk) begin
  if (reset) begin
    state <= OFF;
    out <= 1'b0;
  end else begin
    state <= next_state;
    out <= out_reg;
  end
end

endmodule