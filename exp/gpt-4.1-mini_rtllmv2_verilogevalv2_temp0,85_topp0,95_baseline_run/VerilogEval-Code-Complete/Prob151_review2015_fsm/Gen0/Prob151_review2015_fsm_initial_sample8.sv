module TopModule (
  input clk,
  input reset,
  input data,
  output reg shift_ena,
  output reg counting,
  input done_counting,
  output reg done,
  input ack
);

  // State encoding
  typedef enum reg [1:0] {
    SEARCH = 2'd0,
    SHIFT  = 2'd1,
    COUNT  = 2'd2,
    DONE   = 2'd3
  } state_t;

  reg [1:0] state, next_state;

  // For pattern detection: shift in bits to check last 4 bits for 1101
  reg [3:0] shift_reg;

  // Counter for 4 clock cycles in SHIFT state
  reg [2:0] shift_count;  // 3 bits to hold up to 4

  // Pattern to detect: 1101 (binary 4'b1101 = 13 decimal)
  localparam [3:0] PATTERN = 4'b1101;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      shift_reg <= 4'b0000;
      shift_count <= 3'd0;
    end else begin
      state <= next_state;

      if (state == SEARCH) begin
        // Shift in new bit from data
        shift_reg <= {shift_reg[2:0], data};
      end

      if (state == SHIFT) begin
        // Increment shift_count
        shift_count <= shift_count + 1;
      end else begin
        // Reset shift_count outside SHIFT state
        shift_count <= 3'd0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      SEARCH: begin
        // If pattern detected, go to SHIFT, else stay SEARCH
        if (shift_reg == PATTERN)
          next_state = SHIFT;
        else
          next_state = SEARCH;
      end

      SHIFT: begin
        // After 4 cycles of shift_ena, go to COUNT
        if (shift_count == 3'd3)  // counting from 0 to 3 means 4 cycles
          next_state = COUNT;
        else
          next_state = SHIFT;
      end

      COUNT: begin
        // Wait for done_counting to be high
        if (done_counting)
          next_state = DONE;
        else
          next_state = COUNT;
      end

      DONE: begin
        // Wait for ack, then return to SEARCH
        if (ack)
          next_state = SEARCH;
        else
          next_state = DONE;
      end

      default: next_state = SEARCH;
    endcase
  end

  // Output logic (Moore machine, outputs depend only on state)
  always @(*) begin
    shift_ena = 1'b0;
    counting  = 1'b0;
    done      = 1'b0;

    case (state)
      SHIFT: shift_ena = 1'b1;
      COUNT: counting  = 1'b1;
      DONE:  done      = 1'b1;
      default: ;
    endcase
  end

endmodule