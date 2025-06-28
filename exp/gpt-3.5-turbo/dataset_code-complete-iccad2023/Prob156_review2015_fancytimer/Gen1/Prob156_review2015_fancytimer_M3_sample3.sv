module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // State definitions
  typedef enum logic [3:0] { SEARCH, PATTERN, COUNTING, WAIT_ACK } state_t;
  state_t state;
  reg [3:0] delay;
  reg [11:0] counter;

  always @ (posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      counting <= 0;
      done <= 0;
      counter <= 0;
      delay <= 4'b0;
    end
    else begin
      case(state)
        SEARCH: begin
          if (data == 4'b1101) begin
            state <= PATTERN;
          end
        end

        PATTERN: begin
          delay <= {data, delay[3:1]}; // Shift in the delay bits
          counter <= 0;
          state <= COUNTING;
        end

        COUNTING: begin
          if (counter < (delay + 1) * 1000) begin
            counting <= 1;
            counter <= counter + 1;
          end
          else begin
            counting <= 0;
            done <= 1;
            state <= WAIT_ACK;
          end
        end

        WAIT_ACK: begin
          if (ack) begin
            state <= SEARCH;
            done <= 0;
          end
        end
      endcase
    end
  end

  // Output assignment
  always @* begin
    count = (state == COUNTING) ? (delay - counter[11:8]) : 4'bxxxx;
  end

endmodule