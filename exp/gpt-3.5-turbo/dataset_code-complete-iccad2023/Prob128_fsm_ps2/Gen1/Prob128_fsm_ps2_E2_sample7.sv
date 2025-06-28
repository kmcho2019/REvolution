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
parameter BYTE3 = 2'b11;

// Define signals
reg [1:0] state, next_state;
reg [1:0] cnt;

// Sequential logic
always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    cnt <= 0;
    done <= 0;
  end else begin
    state <= next_state;
    cnt <= (next_state == state) ? cnt : cnt + 1;
  end
end

// Combinational logic
always @(*) begin
  // Default next state
  next_state = state;
  done = 0;

  case (state)
    IDLE: begin
      if (in[3] == 1) begin
        next_state = BYTE1;
        cnt <= 0;
      end
    end

    BYTE1: begin
      if (in[3] == 1) begin
        next_state = BYTE1;
        cnt <= 0;
      end else begin
        next_state = BYTE2;
      end
    end

    BYTE2: begin
      if (in[3] == 1) begin
        next_state = BYTE1;
        cnt <= 0;
      end else begin
        next_state = BYTE3;
      end
    end

    BYTE3: begin
      if (in[3] == 1 && cnt == 2) begin
        next_state = IDLE;
        done = 1;
      end else begin
        next_state = IDLE;
      end
    end
  endcase
end

endmodule