module TopModule (
  input  clk,
  input  reset,
  input  data,
  input  done_counting,
  input  ack,
  output reg shift_ena,
  output reg counting,
  output reg done
);

// Define the states
enum logic [2:0] {
  IDLE,
  SHIFT,
  COUNT,
  DONE
} state, next_state;

reg [3:0] shift_count;

always @(*) begin
  case(state)
    IDLE: begin
      if (data == 1'b1) begin
        if (shift_count == 4'd0) next_state = IDLE;
        else if (shift_count == 4'd1 && ~data) next_state = IDLE;
        else if (shift_count == 4'd2 && data) next_state = IDLE;
        else if (shift_count == 4'd3 && ~data) next_state = SHIFT;
        else next_state = IDLE;
        if (data == 1'b1 && shift_count == 4'd0) shift_count = 4'd1;
        else if (data == 1'b0 && shift_count == 4'd1) shift_count = 4'd2;
        else if (data == 1'b1 && shift_count == 4'd2) shift_count = 4'd3;
        else if (data == 1'b0 && shift_count == 4'd3) shift_count = 4'd0;
      end else begin
        next_state = IDLE;
        shift_count = 4'd0;
      end
      shift_ena = 1'b0;
      counting = 1'b0;
      done = 1'b0;
    end
    SHIFT: begin
      shift_ena = 1'b1;
      counting = 1'b0;
      done = 1'b0;
      if (shift_count < 4'd4) begin
        next_state = SHIFT;
        shift_count = shift_count + 1;
      end else begin
        next_state = COUNT;
        shift_count = 4'd0;
      end
    end
    COUNT: begin
      shift_ena = 1'b0;
      counting = 1'b1;
      done = 1'b0;
      if (done_counting) next_state = DONE;
      else next_state = COUNT;
    end
    DONE: begin
      shift_ena = 1'b0;
      counting = 1'b0;
      done = 1'b1;
      if (ack) next_state = IDLE;
      else next_state = DONE;
    end
    default: next_state = IDLE;
  endcase
end

always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    shift_count <= 4'd0;
  end else begin
    state <= next_state;
  end
end

endmodule