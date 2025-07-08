module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  // States
  typedef enum logic [0:0] {
    IDLE = 1'b0,
    RECV = 1'b1
  } state_t;

  state_t state, next_state;
  reg [1:0] byte_count; // count from 1 to 3

  // State and counter update
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      byte_count <= 2'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      
      // done should be deasserted except for cycle after 3rd byte
      done <= 1'b0;

      if (state == IDLE) begin
        if (in[3] == 1'b1) begin
          byte_count <= 2'd1;
        end else begin
          byte_count <= 2'd0;
        end
      end else if (state == RECV) begin
        byte_count <= byte_count + 2'd1;
        if (byte_count == 2'd3) begin
          // done will be asserted next cycle by next_state logic
        end
      end
    end
  end

  // Next state and done logic combinational
  always @(*) begin
    next_state = state;
    done = 1'b0;

    case (state)
      IDLE: begin
        if (in[3] == 1'b1) begin
          next_state = RECV;
        end
      end
      RECV: begin
        if (byte_count == 2'd3) begin
          done = 1'b1;
          next_state = IDLE;
        end
      end
    endcase
  end

endmodule