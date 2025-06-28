module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output wire [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  reg [3:0] delay;
  reg [3:0] count_reg;
  reg detect_pattern;

  always @ (posedge clk) begin
    if (reset) begin
      counting <= 0;
      done <= 0;
      count <= 4'bxxxx;
      detect_pattern <= 0;
      delay <= 4'b0000;
    end
    else begin
      if (!detect_pattern && (data == 4'b1101)) begin
        detect_pattern <= 1;
      end
      if (detect_pattern) begin
        if (counting) begin
          if (delay > 0) begin
            delay <= delay - 1;
            count_reg <= delay;
          end
          else begin
            counting <= 0;
            done <= 1;
          end
        end
        else if (!counting && ack) begin
          detect_pattern <= 0;
          delay <= 4'b0000;
        end
        else begin
          delay <= data;
          counting <= 1;
        end
      end
    end
  end

  assign count = counting ? count_reg : 4'bxxxx;

endmodule