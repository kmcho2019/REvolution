module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output done
);

// Define states
parameter IDLE = 2'b00;
parameter FIRST_BYTE = 2'b01;
parameter SECOND_BYTE = 2'b10;
parameter THIRD_BYTE = 2'b11;

// Define signals
reg [1:0] state, next_state;
reg message_received;

// Sequential logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    message_received <= 0;
  end else begin
    state <= next_state;
    message_received <= (state == THIRD_BYTE) ? 1'b1 : 1'b0;
  end
end

// Combinational logic
always @(*) begin
  // Default next state
  next_state = state;

  case (state)
    IDLE: begin
      if (in[3] == 1) begin
        next_state = FIRST_BYTE;
      end
    end

    FIRST_BYTE: begin
      if (in[3] == 0) begin
        next_state = IDLE; // Discard message if does not start with in[3]=1
      end else begin
        next_state = SECOND_BYTE;
      end
    end

    SECOND_BYTE: begin
      next_state = (in[3] == 1) ? THIRD_BYTE : IDLE;
    end

    THIRD_BYTE: begin
      next_state = IDLE;
    end
  endcase
end

// Output logic
assign done = message_received;

endmodule