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
reg [3:0] remaining_time;
reg [3:0] shift_in;
reg [2:0] shift_cnt;
reg start_search;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    counting <= 0;
    done <= 0;
    delay <= 4'b0;
    shift_in <= 4'b0;
    shift_cnt <= 3'b0;
    start_search <= 1'b0;
    count <= 4'b0;
    remaining_time <= 4'b0;
  end else begin
    // State machine
    case(counting)
      0: begin // IDLE
        if (data == 1 && shift_in[3] == 1 && start_search == 0) begin
          start_search <= 1;
        end

        if (data == 1 && shift_in[3] == 1 && start_search == 1) begin
          count <= 4'b0;
          remaining_time <= 4'b0;
          shift_in <= 4'b0;
          shift_cnt <= 0;
          start_search <= 0;
          delay <= {shift_in[2:0], data};
          counting <= 1;
        end
      end

      1: begin // COUNTING
        if (remaining_time == 0) begin
          done <= 1;
          counting <= 2;
        end else begin
          remaining_time <= remaining_time - 1;
        end
      end

      2: begin // WAIT_ACK
        if (ack == 1) begin
          done <= 0;
          counting <= 0;
        end
      end

      default: counting <= 0;
    endcase
  end
end

endmodule