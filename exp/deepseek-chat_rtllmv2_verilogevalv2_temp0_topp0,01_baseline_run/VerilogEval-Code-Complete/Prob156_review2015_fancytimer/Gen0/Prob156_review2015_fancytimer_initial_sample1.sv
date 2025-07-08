module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output wire [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

  // FSM states
  localparam IDLE       = 2'b00;
  localparam SHIFT_DELAY = 2'b01;
  localparam COUNTING    = 2'b10;
  localparam DONE        = 2'b11;

  reg [1:0] state, next_state;
  reg [3:0] pattern_reg;  // For detecting 1101
  reg [3:0] delay_reg;    // Stores the delay value
  reg [2:0] shift_count;  // Counts 4 bits for delay
  reg [9:0] cycle_count;  // Counts up to 1000
  reg [3:0] delay_counter; // Current remaining delay

  // Pattern detection
  always @(posedge clk) begin
    if (reset) begin
      pattern_reg <= 4'b0;
    end else if (state == IDLE) begin
      pattern_reg <= {pattern_reg[2:0], data};
    end
  end

  // Delay value capture
  always @(posedge clk) begin
    if (reset) begin
      delay_reg <= 4'b0;
      shift_count <= 3'b0;
    end else if (state == SHIFT_DELAY) begin
      if (shift_count < 4) begin
        delay_reg <= {delay_reg[2:0], data};
        shift_count <= shift_count + 1;
      end
    end else begin
      shift_count <= 3'b0;
    end
  end

  // Cycle counter (counts up to 1000)
  always @(posedge clk) begin
    if (reset || state != COUNTING) begin
      cycle_count <= 10'b0;
    end else if (cycle_count == 10'd999) begin
      cycle_count <= 10'b0;
    end else begin
      cycle_count <= cycle_count + 1;
    end
  end

  // Delay counter (decrements every 1000 cycles)
  always @(posedge clk) begin
    if (reset || state != COUNTING) begin
      delay_counter <= delay_reg;
    end else if (cycle_count == 10'd999) begin
      if (delay_counter > 0)
        delay_counter <= delay_counter - 1;
    end
  end

  // FSM state transition
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // FSM next state logic
  always @(*) begin
    case (state)
      IDLE: begin
        if (pattern_reg == 4'b1101)
          next_state = SHIFT_DELAY;
        else
          next_state = IDLE;
      end
      SHIFT_DELAY: begin
        if (shift_count == 4)
          next_state = COUNTING;
        else
          next_state = SHIFT_DELAY;
      end
      COUNTING: begin
        if (delay_counter == 0 && cycle_count == 10'd999)
          next_state = DONE;
        else
          next_state = COUNTING;
      end
      DONE: begin
        if (ack)
          next_state = IDLE;
        else
          next_state = DONE;
      end
      default: next_state = IDLE;
    endcase
  end

  // Output logic
  always @(posedge clk) begin
    if (reset) begin
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      case (next_state)
        COUNTING: begin
          counting <= 1'b1;
          done <= 1'b0;
        end
        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
        end
        default: begin
          counting <= 1'b0;
          done <= 1'b0;
        end
      endcase
    end
  end

  assign count = (state == COUNTING) ? delay_counter : 4'b0;

endmodule