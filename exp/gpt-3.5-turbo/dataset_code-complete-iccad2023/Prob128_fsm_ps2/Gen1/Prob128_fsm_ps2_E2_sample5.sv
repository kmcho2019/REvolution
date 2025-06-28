module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter DONE = 2'b11;

// Define state register
reg [1:0] state, next_state;

// Sequential logic
always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

// Combinational logic
always @(*) begin
  next_state = state;

  case (state)
    IDLE: begin
      if (in[3] == 1)
        next_state = BYTE1;
    end

    BYTE1: begin
      if (in[3] == 1)
        next_state = BYTE2;
      else
        next_state = IDLE;
    end

    BYTE2: begin
      if (in[3] == 1)
        next_state = DONE;
      else
        next_state = IDLE;
    end

    DONE: begin
      next_state = IDLE;
    end
  endcase
end

// Output logic
assign done = (state == DONE);

endmodule