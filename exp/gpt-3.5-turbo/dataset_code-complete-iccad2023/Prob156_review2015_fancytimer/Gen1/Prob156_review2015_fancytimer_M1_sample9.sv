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
  parameter SEARCH = 2'b00;
  parameter READ_DELAY = 2'b01;
  parameter COUNTING = 2'b10;
  parameter DONE = 2'b11;

  // Internal signals
  reg [1:0] state;
  reg [3:0] delay;
  reg [15:0] remaining_cycles;

  always @ (posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      counting <= 0;
      done <= 0;
      remaining_cycles <= 0;
    end
    else begin
      case (state)
        SEARCH: begin
          if (data == 4'b1101) begin
            state <= READ_DELAY;
          end
        end
        READ_DELAY: begin
          delay <= {data[3], delay[3:1]}; // Update delay with the latest data bit
          state <= COUNTING;
          remaining_cycles <= (delay + 1) * 1000;
        end
        COUNTING: begin
          if (remaining_cycles > 0) begin
            counting <= 1;
            remaining_cycles <= remaining_cycles - 1;
          end
          else begin
            counting <= 0;
            done <= 1;
            state <= DONE;
          end
        end
        DONE: begin
          if (ack) begin
            state <= SEARCH;
            done <= 0;
          end
        end
      endcase
    end
  end

  // Output assignment for remaining time
  assign count = (counting) ? (remaining_cycles - 1) / 1000 : 4'bxxxx;

endmodule