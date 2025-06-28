module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  parameter IDLE = 2'b00, DETECTING_START = 2'b01, READING_DELAY = 2'b10, COUNTING = 2'b11;
  
  reg [1:0] state;
  reg [3:0] delay;
  reg [15:0] counter;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      count <= 4'b1111;
      counter <= 16'd0;
    end
    else begin
      case (state)
        IDLE: begin
          if (data == 4'b1101) begin
            state <= DETECTING_START;
          end
        end
        DETECTING_START: begin
          state <= READING_DELAY;
        end
        READING_DELAY: begin
          delay <= {data, delay[3:1]};
          count <= delay;
          counter <= (delay + 1) * 1000;
          state <= COUNTING;
          counting <= 1;
        end
        COUNTING: begin
          if (counter > 0) begin
            counter <= counter - 1;
            if (counter % 1000 == 0) begin
              count <= count - 1;
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

  always @(posedge clk) begin
    if (done && ack) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      count <= 4'b1111;
      counter <= 0;
    end
  end

endmodule