module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output wire [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

// State definitions
parameter SEARCH_START = 2'b00,
          READ_DELAY = 2'b01,
          COUNTING = 2'b10,
          TIMER_DONE = 2'b11;

reg [1:0] state, next_state;
reg [3:0] delay;
reg [3:0] remaining_count;
reg [11:0] counter;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= SEARCH_START;
    done <= 0;
    counting <= 0;
    delay <= 4'b0;
    remaining_count <= 4'b0;
    counter <= 12'b0;
  end
  else begin
    state <= next_state;
    case (state)
      SEARCH_START: begin
        if (data == 4'b1101) begin
          next_state <= READ_DELAY;
        end
        else begin
          next_state <= SEARCH_START;
        end
      end
      READ_DELAY: begin
        delay <= data;
        remaining_count <= delay;
        counter <= 12'b0;
        next_state <= COUNTING;
      end
      COUNTING: begin
        if (counter < (remaining_count + 1) * 1000 - 1) begin
          counter <= counter + 1;
          if (counter % 1000 == 0 && remaining_count > 0) begin
            remaining_count <= remaining_count - 1;
          end
        end
        else begin
          next_state <= TIMER_DONE;
        end
      end
      TIMER_DONE: begin
        done <= 1;
        counting <= 0;
        if (ack) begin
          next_state <= SEARCH_START;
        end
        else begin
          next_state <= TIMER_DONE;
        end
      end
    endcase
  end
end

assign count = counting ? remaining_count : 4'b0;

endmodule