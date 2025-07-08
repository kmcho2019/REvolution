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
  IDLE = 2'b00,
  SHIFT = 2'b01,
  COUNT = 2'b10,
  DONE = 2'b11
} state_t;

reg [1:0] state, next_state;

// To detect pattern 1101, keep a 4-bit shift register of last 4 bits
reg [3:0] shift_reg;
wire pattern_found = (shift_reg == 4'b1101);

// Counter for 4 cycles shift_ena
reg [2:0] shift_count; // need max 4 count

// State transition and outputs
always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    shift_reg <= 4'b0000;
    shift_ena <= 0;
    counting <= 0;
    done <= 0;
    shift_count <= 0;
  end else begin
    state <= next_state;

    // Shift in data for pattern detection only in IDLE state
    if (state == IDLE) begin
      shift_reg <= {shift_reg[2:0], data};
    end

    // Default outputs
    shift_ena <= 0;
    counting <= 0;
    done <= 0;

    case (state)
      IDLE: begin
        // nothing asserted here, shifting already done above
      end
      SHIFT: begin
        shift_ena <= 1;
        shift_count <= shift_count + 1;
      end
      COUNT: begin
        counting <= 1;
      end
      DONE: begin
        done <= 1;
      end
    endcase

    // Reset shift_count when not in SHIFT
    if (state != SHIFT)
      shift_count <= 0;
  end
end

// Next state logic combinational
always @(*) begin
  next_state = state;
  case (state)
    IDLE: begin
      if (pattern_found) begin
        next_state = SHIFT;
      end
    end
    SHIFT: begin
      if (shift_count == 3) // 0 to 3 counts = 4 cycles
        next_state = COUNT;
    end
    COUNT: begin
      if (done_counting)
        next_state = DONE;
    end
    DONE: begin
      if (ack)
        next_state = IDLE;
    end
  endcase
end

endmodule