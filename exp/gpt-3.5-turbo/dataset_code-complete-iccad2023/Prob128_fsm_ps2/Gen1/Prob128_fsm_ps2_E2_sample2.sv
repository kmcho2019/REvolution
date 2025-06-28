module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 3'b000;
parameter BYTE1 = 3'b001;
parameter BYTE2 = 3'b010;
parameter VALIDATE = 3'b011;
parameter DONE = 3'b100;

// Define signals
reg [2:0] state, next_state;

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
        next_state = BYTE1;
      end
    end

    BYTE1: begin
      if (in[3] == 0) begin
        next_state = IDLE;
      end else begin
        next_state = BYTE2;
      end
    end

    BYTE2: begin
      if (in[3] == 0) begin
        next_state = IDLE;
      end else begin
        next_state = VALIDATE;
      end
    end

    VALIDATE: begin
      if (in[3] == 0) begin
        next_state = IDLE;
      end else begin
        next_state = DONE;
      end
    end

    DONE: begin
      next_state = IDLE;
      done = 1;
    end
  endcase
end

// Reset 'done' signal
always @(posedge clk) begin
  if (reset)
    done <= 0;
end

endmodule