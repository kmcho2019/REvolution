module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output wire [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

typedef enum logic [2:0] {
  SEARCH,
  RECEIVE,
  COUNT,
  DONE
} state_t;

reg [3:0] delay;
reg [2:0] state;
reg [15:0] counter;

always @(posedge clk) begin
  if (reset) begin
    state <= SEARCH;
    counting <= 0;
    done <= 0;
    counter <= 0;
    delay <= 0;
  end
  else begin
    case(state)
      SEARCH: if ((data == 4'b1101) && (counter == 0)) begin
        state <= RECEIVE;
        counter <= 3;
      end
      else counter <= counter ? counter - 1 : 0;
      
      RECEIVE: if (counter == 0) begin
        delay <= data;
        state <= COUNT;
        counting <= 1;
        counter <= 999;
      end
      else counter <= counter ? counter - 1 : 0;
      
      COUNT: if (counter == 0) begin
        if (delay == 0) state <= DONE;
        else begin
          delay <= delay ? delay - 1 : 0;
          counter <= 999;
        end
      end
      else counter <= counter ? counter - 1 : 0;
      
      DONE: if (ack) begin
        state <= SEARCH;
        counting <= 0;
        done <= 1;
        counter <= 0;
        delay <= 0;
      end
    endcase
  end
end

assign count = counting ? delay : 4'bxxxx;

endmodule