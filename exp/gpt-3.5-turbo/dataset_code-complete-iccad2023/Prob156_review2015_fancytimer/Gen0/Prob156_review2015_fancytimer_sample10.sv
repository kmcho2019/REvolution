module Timer (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  parameter IDLE = 2'b00;
  parameter DETECT_1101 = 2'b01;
  parameter COUNTING = 2'b10;
  
  reg [3:0] delay;
  reg [3:0] counter;
  reg [3:0] remaining_time;
  reg [3:0] shift_reg;
  reg [1:0] state;

  always @ (posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (data == 4'b1101) begin
            shift_reg <= 4'b0;
            state <= DETECT_1101;
          end
        end
        DETECT_1101: begin
          shift_reg <= {shift_reg[2:0], data};
          delay <= shift_reg;
          state <= COUNTING;
          counting <= 1;
          counter <= 0;
          remaining_time <= delay;
        end
        COUNTING: begin
          if (counter == delay + 1) begin
            counting <= 0;
            done <= 1;
          end else begin
            counter <= counter + 1;
            if (counter % 1000 == 0) begin
              remaining_time <= remaining_time - 1;
            end
          end
        end
      endcase
    end
  end

  always @ (posedge clk) begin
    if (reset) begin
      count <= 4'bxxxx;
    end else begin
      if (counting) begin
        count <= remaining_time;
      end else begin
        count <= 4'bxxxx;
      end
    end
  end

endmodule