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
parameter SEARCH_START = 2'b00;
parameter READ_DELAY = 2'b01;
parameter COUNTING = 2'b10;
parameter TIMER_DONE = 2'b11;

// Internal signals
reg [1:0] state;
reg [3:0] delay;
reg [12:0] timer; // Using 13 bits to allow for accurate 1000-cycle counting

always @ (posedge clk) begin
  if (reset)
    state <= SEARCH_START;
  else
    case (state)
      SEARCH_START: begin
        if (data == 4'b1101) begin
          state <= READ_DELAY;
          delay <= 0;
        end
      end
      READ_DELAY: begin
        delay <= data;
        state <= COUNTING;
        timer <= (delay + 1) * 1000;
        counting <= 1;
        count <= delay;
      end
      COUNTING: begin
        if (timer > 0) begin
          timer <= timer - 1;
          if (timer % 1000 == 0 && delay > 0)
            delay <= delay - 1;
        end
        else begin
          state <= TIMER_DONE;
          counting <= 0;
          done <= 1;
        end
      end
      TIMER_DONE: begin
        if (ack) begin
          state <= SEARCH_START;
          done <= 0;
          count <= 4'bxxxx;
        end
      end
    endcase
end

endmodule