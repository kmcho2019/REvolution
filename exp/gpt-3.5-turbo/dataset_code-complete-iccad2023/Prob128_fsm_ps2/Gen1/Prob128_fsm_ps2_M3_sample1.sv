module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output done
);

// Define states
parameter IDLE = 2'b00;
parameter CHECK_SECOND_BYTE = 2'b01;
parameter CHECK_THIRD_BYTE = 2'b10;
parameter DONE = 2'b11;

// Define signals
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
  // Default next state
  next_state = state;

  case (state)
    IDLE: begin
      if (in[3] == 1) begin
        next_state = CHECK_SECOND_BYTE;
      end
    end

    CHECK_SECOND_BYTE: begin
      if (in[3] == 1) begin
        next_state = CHECK_THIRD_BYTE;
      end
    end

    CHECK_THIRD_BYTE: begin
      if (in[3] == 1) begin
        next_state = DONE;
      end
    end

    DONE: begin
      next_state = IDLE;
    end
  endcase
end

// Output logic
assign done = (state == DONE);

endmodule