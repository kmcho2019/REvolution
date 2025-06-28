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
  reg [3:0] count_reg;
  reg [3:0] remaining_time;
  reg [3:0] shift_reg;
  reg [2:0] shift_cnt;
  reg previous_data;
  reg start_search;

  always @(*) begin
    case (shift_cnt)
      0: shift_reg = {data, shift_reg[3:1]};
      1: shift_reg = {data, shift_reg[3:1]};
      2: shift_reg = {data, shift_reg[3:1]};
      3: shift_reg = {data, shift_reg[3:1]};
      4: begin
        delay = shift_reg;
        counting = 1;
        count_reg = delay + 1;
        remaining_time = delay;
      end
      default: shift_reg = shift_reg; // No operation
    endcase
  end

  always @(posedge clk) begin
    if (reset) begin
      counting <= 0;
      done <= 0;
      shift_reg <= 4'b0;
      shift_cnt <= 0;
      count_reg <= 4'b0;
    end
    else begin
      case (counting)
        0: count_reg <= 4'b0;
        1: begin
             if (count_reg > 0)
               count_reg <= count_reg - 1;
             else begin
               counting <= 0;
               done <= 1;
             end
           end
      endcase
    end
  end

  always @(posedge clk) begin
    if (done && ack) begin
      counting <= 0;
      done <= 0;
      count_reg <= 4'b0;
      shift_reg <= 4'b0;
      shift_cnt <= 0;
    end
  end

  always @(posedge clk) begin
    if (reset)
      start_search <= 0;
    else if (data == 1 && previous_data == 1 && start_search == 0)
      start_search <= 1;
    previous_data <= data;
  end

  assign count = counting ? remaining_time : 4'bxxxx;

endmodule