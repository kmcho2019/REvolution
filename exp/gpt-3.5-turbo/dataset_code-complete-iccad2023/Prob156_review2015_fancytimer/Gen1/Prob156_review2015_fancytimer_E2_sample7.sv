module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  typedef enum logic [3:0] {IDLE, DETECT_PATTERN, READ_DELAY, COUNT} state_t;
  reg [3:0] delay;
  reg [3:0] count_reg;
  reg [3:0] remaining_time;
  reg [2:0] timer;
  state_t state;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      delay <= 4'b0;
      count <= 4'b0;
      counting <= 0;
      done <= 0;
      timer <= 3'b0;
    end
    else begin
      case (state)
        IDLE: begin
          if (data == 4'b1101) begin
            state <= DETECT_PATTERN;
          end
        end
        DETECT_PATTERN: begin
          state <= READ_DELAY;
        end
        READ_DELAY: begin
          delay <= {data, delay[3:1]};
          count_reg <= delay + 1;
          remaining_time <= delay;
          state <= COUNT;
          counting <= 1;
        end
        COUNT: begin
          if (counting) begin
            if (timer < 1000) begin
              timer <= timer + 1;
            end
            else begin
              remaining_time <= remaining_time - 1;
              count_reg <= count_reg - 1;
              count <= remaining_time;
              timer <= 0;
              if (remaining_time == 0) begin
                counting <= 0;
                done <= 1;
                state <= IDLE;
              end
            end
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if (done && ack) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      count <= 4'b0;
      delay <= 4'b0;
      count_reg <= 4'b0;
      remaining_time <= 4'b0;
      timer <= 3'b0;
    end
  end

endmodule