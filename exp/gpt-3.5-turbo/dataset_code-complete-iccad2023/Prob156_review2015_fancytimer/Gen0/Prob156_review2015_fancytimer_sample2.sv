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
parameter START = 2'b00;
parameter READ_DELAY = 2'b01;
parameter COUNT = 2'b10;
parameter DONE = 2'b11;

// Internal signals
reg [1:0] state;
reg [3:0] delay;
reg [31:0] timer;

always @ (posedge clk) begin
  if (reset) begin
    state <= START;
    done <= 0;
    count <= 4'bxxxx;
    counting <= 0;
  end
  else begin
    case (state)
      START: begin
        if (data == 4'b1101) begin
          state <= READ_DELAY;
          delay <= 0;
        end
      end
      READ_DELAY: begin
        delay <= {delay[2:0], data};
        state <= COUNT;
        counting <= 1;
        timer <= (delay + 1) * 1000 - 1;
      end
      COUNT: begin
        if (timer > 0) begin
          timer <= timer - 1;
          if (timer % 1000 == 0) begin
            if (delay > 0)
              delay <= delay - 1;
            count <= delay;
          end
        end
        else begin
          state <= DONE;
          counting <= 0;
          done <= 1;
        end
      end
      DONE: begin
        if (ack) begin
          state <= START;
          done <= 0;
          count <= 4'bxxxx;
        end
      end
    endcase
  end
end

endmodule