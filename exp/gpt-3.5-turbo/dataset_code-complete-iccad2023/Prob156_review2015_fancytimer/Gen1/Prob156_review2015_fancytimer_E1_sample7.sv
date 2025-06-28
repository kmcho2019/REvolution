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
parameter SEARCH_START = 2'b00,
          DETECT_PATTERN = 2'b01,
          DELAY_COUNTDOWN = 2'b10,
          WAIT_ACK = 2'b11;

reg [1:0] state, next_state;
reg [3:0] delay;
reg [3:0] count_reg;
reg [3:0] remaining_time;
reg [15:0] countdown;
reg [3:0] pattern_shift_reg;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= SEARCH_START;
    done <= 0;
    counting <= 0;
    delay <= 0;
    count_reg <= 0;
    remaining_time <= 0;
    countdown <= 0;
    pattern_shift_reg <= 0;
  end
  else begin
    state <= next_state;
    
    // State transitions
    case (state)
      SEARCH_START: begin
        if (data == 4'b1101) begin
          pattern_shift_reg <= {pattern_shift_reg[2:0], data}; // Shift in 4 bits
          next_state <= DETECT_PATTERN;
        end
        else begin
          next_state <= SEARCH_START;
        end
      end
      DETECT_PATTERN: begin
        delay <= pattern_shift_reg[3:0]; // Extract delay value
        next_state <= DELAY_COUNTDOWN;
      end
      DELAY_COUNTDOWN: begin
        if (countdown < (delay + 1) * 1000) begin
          counting <= 1;
          countdown <= countdown + 1;
          if (countdown % 1000 == 0) begin
            remaining_time <= delay - (countdown / 1000) + 1; // Update remaining time
          end
          if (countdown == (delay + 1) * 1000) begin
            counting <= 0;
            done <= 1;
            next_state <= WAIT_ACK;
          end
        end
        else begin
          next_state <= DELAY_COUNTDOWN;
        end
      end
      WAIT_ACK: begin
        if (ack) begin
          done <= 0;
          countdown <= 0;
          next_state <= SEARCH_START;
        end
        else begin
          next_state <= WAIT_ACK;
        end
      end
    endcase
  end
end

assign count = counting ? remaining_time : 4'b0;

endmodule