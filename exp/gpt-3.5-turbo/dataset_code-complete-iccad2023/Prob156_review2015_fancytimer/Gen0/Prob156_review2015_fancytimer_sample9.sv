module Timer (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

// State definitions
parameter IDLE = 2'b00;
parameter DETECT_PATTERN = 2'b01;
parameter READ_DELAY = 2'b10;
parameter COUNTING = 2'b11;

reg [1:0] state;
reg [1:0] nextState;
reg [3:0] delay;
reg [3:0] remaining_time;
reg [3:0] counter;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    counting <= 1'b0;
    done <= 1'b0;
    delay <= 4'b0000;
    counter <= 4'b0000;
    remaining_time <= 4'b0000;
    count <= 4'bxxxx;
  end else begin
    state <= nextState;
    if (counting) begin
      if (counter == delay) begin
        remaining_time <= remaining_time - 1;
        counter <= 4'b0000;
      end else begin
        counter <= counter + 1;
      end
    end
  end
end

always @(*) begin
  case (state)
    IDLE: begin
      if (data == 1) nextState = DETECT_PATTERN;
      else nextState = IDLE;
    end
    DETECT_PATTERN: begin
      if (data == 0) nextState = DETECT_PATTERN;
      else begin
        nextState = READ_DELAY;
      end
    end
    READ_DELAY: begin
      delay <= {delay[2:0], data};
      nextState = COUNTING;
      counting <= 1;
      remaining_time <= delay;
    end
    COUNTING: begin
      if (remaining_time == 0) begin
        counting <= 0;
        done <= 1;
        if (ack) begin
          nextState = IDLE;
        end
      end else begin
        nextState = COUNTING;
      end
    end
  endcase
end

assign count = (counting) ? remaining_time : 4'bxxxx;

endmodule