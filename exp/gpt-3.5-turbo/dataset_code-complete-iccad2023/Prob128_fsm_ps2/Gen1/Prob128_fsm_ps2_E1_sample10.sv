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

// Define signals
reg [1:0] state, next_state;
reg [1:0] byte_counter;

// Sequential logic
always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    byte_counter <= 2'b00;
  end
  else begin
    state <= next_state;
    byte_counter <= (state == IDLE) ? 2'b00 : byte_counter + 1;
  end
end

// Combinational logic
always @* begin
  // Default next state
  next_state = state;

  case (state)
    IDLE: begin
      if (in[3] == 1) begin
        next_state = BYTE1;
      end
    end

    BYTE1: begin
      if (in[3] == 1) begin
        next_state = IDLE;
      end else begin
        next_state = BYTE2;
      end
    end

    BYTE2: begin
      if (in[3] == 1) begin
        next_state = IDLE;
      end else if (byte_counter == 2) begin
        next_state = DONE;
      end
    end

    DONE: begin
      next_state = IDLE;
    end
  endcase
end

endmodule