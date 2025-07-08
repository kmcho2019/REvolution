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
  typedef enum logic [1:0] {
    SEARCH = 2'b00,
    SHIFT  = 2'b01,
    COUNT  = 2'b10,
    DONE   = 2'b11
  } state_t;
  
  state_t state, next_state;
  
  reg [3:0] shift_reg;       // shift register to detect pattern 1101
  reg [1:0] shift_count;     // counts 4 cycles of shift_ena asserted
  
  // Synchronous logic for state and shift register
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCH;
      shift_reg <= 4'b0000;
      shift_count <= 2'b00;
      shift_ena <= 1'b0;
      counting <= 1'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;

      // Shift in serial data for pattern detection only in SEARCH state
      if (state == SEARCH) begin
        shift_reg <= {shift_reg[2:0], data};
      end else begin
        // In other states shift_reg not updated
        shift_reg <= shift_reg;
      end

      case (state)
        SEARCH: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b0;
          shift_count <= 2'b00;
        end

        SHIFT: begin
          shift_ena <= 1'b1;
          counting <= 1'b0;
          done <= 1'b0;
          // increment shift_count
          shift_count <= shift_count + 1'b1;
        end

        COUNT: begin
          shift_ena <= 1'b0;
          counting <= 1'b1;
          done <= 1'b0;
          shift_count <= 2'b00;
        end

        DONE: begin
          shift_ena <= 1'b0;
          counting <= 1'b0;
          done <= 1'b1;
          shift_count <= 2'b00;
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      SEARCH: begin
        // pattern 1101 detected?
        if (shift_reg == 4'b1101)
          next_state = SHIFT;
      end

      SHIFT: begin
        // After 4 cycles shift_ena asserted go to COUNT
        if (shift_count == 2'b11)  // counts 0..3 means 4 cycles
          next_state = COUNT;
      end

      COUNT: begin
        // Wait for done_counting
        if (done_counting)
          next_state = DONE;
      end

      DONE: begin
        // Wait for ack
        if (ack)
          next_state = SEARCH;
      end

      default: next_state = SEARCH;
    endcase
  end

endmodule