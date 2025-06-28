module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  reg [3:0] delay;
  reg [3:0] timer_reg;

  parameter IDLE = 2'b00, DETECTING = 2'b01, COUNTING = 2'b10, WAIT_ACK = 2'b11;
  reg [1:0] state = IDLE;

  always @(posedge clk) begin
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
          delay <= {data, delay[3:1]};
          timer_reg <= delay;
          state <= COUNTING;
          counting <= 1;
        end
        COUNTING: begin
          if (timer_reg > 0) begin
            timer_reg <= timer_reg - 1;
            count <= timer_reg;
          end 
          else begin
            counting <= 0;
            done <= 1;
            state <= WAIT_ACK;
            count <= 4'b1111;
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