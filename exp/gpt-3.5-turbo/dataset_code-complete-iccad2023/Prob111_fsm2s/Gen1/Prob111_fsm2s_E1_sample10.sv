module MooreStateMachine #(
  parameter NUM_STATES = 2
)(
  input clk,
  input [NUM_STATES-1:0] inputs,
  input reset,
  output reg out
);

// Define states
localparam [NUM_STATES-1:0] OFF = NUM_STATES'd0;
localparam [NUM_STATES-1:0] ON = NUM_STATES'd1;

// State register and next state logic
reg [NUM_STATES-1:0] state, next_state;

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
      if (inputs == {NUM_STATES{1'b0}}) begin
        next_state = OFF;
      end else begin
        next_state = ON;
      end
    end
    ON: begin
      if (inputs == {NUM_STATES{1'b1}}) begin
        next_state = OFF;
      end else begin
        next_state = ON;
      end
    end
    default: next_state = OFF;
  endcase
end

// Output logic
always @(*) begin
  case(state)
    OFF: out = 1'b0;
    ON: out = 1'b1;
    default: out = 1'b0;
  endcase
end

endmodule

// Top module instantiation
module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

MooreStateMachine #() fsm (
  .clk(clk),
  .inputs({j, k}),
  .reset(reset),
  .out(out)
);

endmodule