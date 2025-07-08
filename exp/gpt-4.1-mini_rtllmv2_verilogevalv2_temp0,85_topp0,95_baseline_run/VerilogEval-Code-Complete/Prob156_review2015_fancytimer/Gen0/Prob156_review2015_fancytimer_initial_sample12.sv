module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // FSM States
  typedef enum reg [2:0] {
    IDLE       = 3'd0,
    LOAD_DELAY = 3'd1,
    COUNTING   = 3'd2,
    DONE       = 3'd3
  } state_t;

  state_t state, next_state;

  // Shift register to detect 1101 pattern
  reg [3:0] pattern_shift;

  // Shift register to load delay bits
  reg [3:0] delay_shift;
  reg [2:0] delay_bits_received; // count bits shifted in LOAD_DELAY state

  // Counters for counting cycles and delay
  reg [9:0] cycle_counter; // counts 0 to 999
  reg [3:0] delay_counter; // counts down delay from loaded delay to 0

  // FSM sequential logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      pattern_shift <= 4'b0000;
      delay_shift <= 4'b0000;
      delay_bits_received <= 3'd0;
      cycle_counter <= 10'd0;
      delay_counter <= 4'd0;
      counting <= 1'b0;
      done <= 1'b0;
      count <= 4'bxxxx;
    end else begin
      state <= next_state;

      case(state)
        IDLE: begin
          // Shift in data into pattern_shift
          pattern_shift <= {pattern_shift[2:0], data};
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'bxxxx;
        end

        LOAD_DELAY: begin
          // Shift in data to delay_shift MSB first
          delay_shift <= {delay_shift[2:0], data};
          delay_bits_received <= delay_bits_received + 1'b1;
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'bxxxx;
        end

        COUNTING: begin
          counting <= 1'b1;
          done <= 1'b0;
          count <= delay_counter;

          if (cycle_counter == 10'd999) begin
            cycle_counter <= 10'd0;
            if (delay_counter != 4'd0) begin
              delay_counter <= delay_counter - 1'b1;
            end
          end else begin
            cycle_counter <= cycle_counter + 1'b1;
          end
        end

        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          count <= 4'bxxxx;
        end

        default: begin
          counting <= 1'b0;
          done <= 1'b0;
          count <= 4'bxxxx;
        end
      endcase
    end
  end

  // FSM combinational logic for next_state
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        // Detect pattern 1101 on pattern_shift
        if (pattern_shift == 4'b1101) begin
          next_state = LOAD_DELAY;
        end
      end

      LOAD_DELAY: begin
        if (delay_bits_received == 3'd4) begin
          next_state = COUNTING;
        end
      end

      COUNTING: begin
        // Counting completes when delay_counter == 0 and cycle_counter == 999
        if ((delay_counter == 4'd0) && (cycle_counter == 10'd999)) begin
          next_state = DONE;
        end
      end

      DONE: begin
        // Wait for ack to reset back to IDLE
        if (ack) begin
          next_state = IDLE;
        end
      end

      default: next_state = IDLE;
    endcase
  end

  // Load delay_counter when entering COUNTING state
  always @(posedge clk) begin
    if (reset) begin
      delay_counter <= 4'd0;
      delay_bits_received <= 3'd0;
    end else begin
      if ((state == LOAD_DELAY) && (delay_bits_received == 3'd4)) begin
        // delay_shift holds MSB-first loaded 4 bits, assign to delay_counter
        delay_counter <= delay_shift;
      end else if (next_state == IDLE) begin
        delay_bits_received <= 3'd0;
      end
    end
  end

  // Reset cycle_counter on transitions into COUNTING state
  reg state_counting_d;
  always @(posedge clk) begin
    if (reset) begin
      cycle_counter <= 10'd0;
      state_counting_d <= 1'b0;
    end else begin
      state_counting_d <= (state == COUNTING);
      if ((state != COUNTING) && (state_counting_d)) begin
        // state is leaving COUNTING, do nothing
      end else if ((state != COUNTING) && (next_state == COUNTING)) begin
        // just entering COUNTING, reset cycle_counter
        cycle_counter <= 10'd0;
      end
    end
  end

endmodule