module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

// Define states
typedef enum logic [2:0] {
  IDLE,
  DETECT_PATTERN,
  READ_DELAY,
  COUNTING
} state_t;

reg [2:0] state;
reg [3:0] delay;
reg [31:0] timer;

always @ (posedge clk) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
    count <= 4'bxxxx;
    counting <= 0;
  end
  else begin
    case (state)
      IDLE: begin
        if (data == 1'b1 && $past(data) == 1'b1) begin
          state <= DETECT_PATTERN;
        end
      end
      DETECT_PATTERN: begin
        if (data == 4'b1101) begin
          state <= READ_DELAY;
          delay <= 0;
        end else begin
          state <= IDLE;
        end
      end
      READ_DELAY: begin
        delay <= {delay[2:0], data};
        state <= COUNTING;
        counting <= 1;
        timer <= (delay + 1) * 1000;
      end
      COUNTING: begin
        if (timer > 0) begin
          timer <= timer - 1;
          if (timer % 1000 == 0) begin
            if (delay > 0)
              delay <= delay - 1;
            count <= delay;
          end
        end else begin
          state <= IDLE;
          counting <= 0;
          done <= 1;
        end
      end
    endcase
  end
end

endmodule