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
parameter IDLE = 2'b00;
parameter START_DETECT = 2'b01;
parameter READ_DELAY = 2'b10;
parameter COUNTING = 2'b11;

// Internal signals
reg [1:0] state;
reg [3:0] delay;
reg [15:0] timer;

always @ (posedge clk) begin
  if (reset) begin
    state <= IDLE; // Reset to initial state
    count <= 4'bxxxx;
    counting <= 0;
    done <= 0;
  end
  else begin
    case (state)
      IDLE: begin
        if (data == 4'b1101) begin
          state <= START_DETECT;
        end
      end
      START_DETECT: begin
        state <= READ_DELAY;
        delay <= 0;
      end
      READ_DELAY: begin
        delay <= {delay[2:0], data};
        state <= COUNTING;
        counting <= 1;
        timer <= (delay + 1) * 1000;
        count <= delay;
      end
      COUNTING: begin
        if (timer > 0) begin
          timer <= timer - 1;
          if (timer % 1000 == 0 && delay > 0) begin
            delay <= delay - 1;
            count <= delay;
          end
        end
        else begin
          state <= IDLE;
          counting <= 0;
          done <= 1;
        end
      end
    endcase
  end
end

endmodule