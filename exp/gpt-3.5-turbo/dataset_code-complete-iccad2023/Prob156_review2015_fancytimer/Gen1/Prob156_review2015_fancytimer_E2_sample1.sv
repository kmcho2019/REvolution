module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  parameter IDLE = 2'b00, DETECTING = 2'b01, READING_DELAY = 2'b10, COUNTING = 2'b11;
  
  reg [1:0] state;
  reg [3:0] delay;
  reg [3:0] count_reg;
  reg [11:0] timer_counter;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      count_reg <= 4'b1111;
      count <= count_reg;
      timer_counter <= 12'b0;
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
          state <= COUNTING;
          counting <= 1;
        end
        COUNTING: begin
          if (timer_counter < (delay + 1) * 1000) begin
            timer_counter <= timer_counter + 1;
            if (timer_counter % 1000 == 0 && count_reg > 0) begin
              count_reg <= count_reg - 1;
            end
          end 
          else begin
            counting <= 0;
            done <= 1;
          end
        end
      endcase
    end
  end

  always @* begin
    count = counting ? count_reg : 4'bxxxx;
  end

  always @(posedge clk) begin
    if (done && ack) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      count_reg <= 4'b1111;
      count <= count_reg;
      timer_counter <= 12'b0;
    end
  end

endmodule