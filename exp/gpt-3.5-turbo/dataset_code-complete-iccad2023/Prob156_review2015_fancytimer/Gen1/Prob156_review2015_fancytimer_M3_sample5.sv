module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  typedef enum logic [1:0] {
      SEARCH,
      DETECTED,
      WAIT_ACK
  } state_type;

  reg [2:0] shift_reg;
  reg [3:0] delay;
  reg [15:0] countdown;

  state_type state;
  reg [3:0] remaining_time;

  always @ (posedge clk or posedge reset) begin
      if (reset) begin
          state <= SEARCH;
          shift_reg <= 3'b0;
          delay <= 0;
          counting <= 0;
          countdown <= 0;
          done <= 0;
      end else begin
          case (state)
              SEARCH: begin
                  if (data == 4'b1101) begin
                      shift_reg <= {shift_reg[1:0], data};
                      delay <= shift_reg[2:0];
                      state <= DETECTED;
                  end
              end
              DETECTED: begin
                  counting <= 1;
                  countdown <= (delay + 1) * 1000;
                  remaining_time <= delay;
                  state <= (countdown == 0) ? WAIT_ACK : DETECTED;
              end
              WAIT_ACK: begin
                  done <= 1;
                  if (ack) begin
                      done <= 0;
                      state <= SEARCH;
                  end
              end
          endcase

          if (counting && countdown > 0) begin
              countdown <= countdown - 1;
              if (countdown % 1000 == 0) begin
                  remaining_time <= (countdown / 1000) == 0 ? 0 : remaining_time - 1;
              end
          end
      end
  end

  assign count = remaining_time;

endmodule