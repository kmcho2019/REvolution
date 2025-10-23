module TopModule (
  input clk,
  input reset,
  input data,
  input done_counting,
  input ack,
  output reg shift_ena,
  output reg counting,
  output reg done
);

reg [2:0] state, next_state;
reg [1:0] count, next_count;

always @(*) begin
  next_state = state;
  next_count = count;
  shift_ena = 1'b0;
  counting = 1'b0;
  done = 1'b0;

  case(state)
    3'b000: begin // IDLE
      if (data) begin
        next_state = 3'b001; // SHIFT1
      end
    end
    3'b001: begin // SHIFT1
      if (data) begin
        next_state = 3'b010; // SHIFT2
      end else begin
        next_state = 3'b000; // IDLE
      end
    end
    3'b010: begin // SHIFT2
      if (data) begin
        next_state = 3'b011; // SHIFT3
      end else begin
        next_state = 3'b000; // IDLE
      end
    end
    3'b011: begin // SHIFT3
      if (data) begin
        next_state = 3'b000; // IDLE
      end else begin
        next_state = 3'b100; // SHIFT4
      end
    end
    3'b100: begin // SHIFT4
      shift_ena = 1'b1;
      next_count = count + 1;
      if (count == 3) begin
        next_state = 3'b101; // COUNT
      end
    end
    3'b101: begin // COUNT
      counting = 1'b1;
      if (done_counting) begin
        next_state = 3'b110; // DONE
      end
    end
    3'b110: begin // DONE
      done = 1'b1;
      if (ack) begin
        next_state = 3'b000; // IDLE
      end
    end
  endcase
end

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 3'b000;
    count <= 2'b00;
  end else begin
    state <= next_state;
    count <= next_count;
  end
end

endmodule