module PatternDetector(
  input wire clk,
  input wire reset,
  input wire data,
  output reg start_detected
);

reg [3:0] shift_reg;
reg [2:0] pattern_cnt;
parameter [3:0] pattern = 4'b1101;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    shift_reg <= 4'b0;
    pattern_cnt <= 3'b0;
    start_detected <= 0;
  end
  else begin
    shift_reg <= {data, shift_reg[3:1]};
    if (shift_reg == pattern && pattern_cnt == 3'b0) begin
      pattern_cnt <= 3'b1;
    end
    else if (shift_reg == pattern && pattern_cnt != 3'b0) begin
      pattern_cnt <= pattern_cnt + 1;
    end
    else begin
      pattern_cnt <= 3'b0;
    end
    if (pattern_cnt == 3'b3) begin
      start_detected <= 1;
    end
  end
end

endmodule

module Timer(
  input wire clk,
  input wire reset,
  input wire start_timer,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

reg [3:0] delay;
reg [31:0] timer;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    delay <= 4'b0;
    counting <= 0;
    done <= 0;
    count <= 4'bxxxx;
  end
  else begin
    if (start_timer) begin
      delay <= data;
      counting <= 1;
      timer <= (delay + 1) * 1000 - 1;
    end
    if (timer > 0) begin
      timer <= timer - 1;
      if (timer % 1000 == 0) begin
        if (delay > 0)
          delay <= delay - 1;
        count <= delay;
      end
    end
    else if (timer == 0) begin
      done <= 1;
    end
    if (done && ack) begin
      done <= 0;
      count <= 4'bxxxx;
    end
  end
end

endmodule

// Top module integrating PatternDetector and Timer modules
module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output wire [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

wire start_timer;
PatternDetector pattern_detector(.clk(clk), .reset(reset), .data(data), .start_detected(start_timer));
Timer timer(.clk(clk), .reset(reset), .start_timer(start_timer), .count(count), .counting(counting), .done(done), .ack(ack));

endmodule