module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  typedef enum logic [2:0] { IDLE, DETECTING, READING_DELAY, COUNTING, WAIT_ACK } state_t;
  
  reg [2:0] state;
  reg [3:0] delay;
  reg [3:0] count_reg;
  reg [3:0] remaining_time;

  always @ (posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      count <= 4'b1111;
    end
    else begin
      case (state)
        IDLE: begin
          if (data == 4'b1101) begin
            state <= DETECTING;
          end
        end
        DETECTING: begin
          state <= READING_DELAY;
        end
        READING_DELAY: begin
          delay <= {data, delay[3:1]};
          count_reg <= delay;
          remaining_time <= delay;
          state <= COUNTING;
          counting <= 1;
        end
        COUNTING: begin
          if (count_reg > 0) begin
            count_reg <= count_reg - 1;
            remaining_time <= (remaining_time > 0) ? remaining_time - 1 : remaining_time;
          end 
          else begin
            counting <= 0;
            done <= 1;
            state <= WAIT_ACK;
          end
        end
        WAIT_ACK: begin
          if (ack) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count <= 4'b1111;
          end
        end
      endcase
    end
  end

endmodule