module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // State encoding
  typedef enum reg [1:0] {
    IDLE = 2'b00,
    DATA = 2'b01,
    STOP = 2'b10,
    WAIT_FOR_STOP = 2'b11
  } state_t;
  
  state_t state, next_state;
  
  reg [3:0] bit_count; // counts bits received (0 to 8)
  
  // State transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      done <= 0;
    end else begin
      state <= next_state;
      done <= 0; // default no done
      
      case(state)
        IDLE: begin
          bit_count <= 0;
        end
        DATA: begin
          bit_count <= bit_count + 1;
        end
        STOP: begin
          // done is asserted here if stop bit correct (next_state == IDLE)
          if (in == 1'b1)
            done <= 1'b1;
        end
        WAIT_FOR_STOP: begin
          // stay until in == 1, then done=0 and back to IDLE
        end
      endcase
    end
  end
  
  // Next state logic combinational
  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if (in == 1'b0) // start bit detected
          next_state = DATA;
        else
          next_state = IDLE;
      end
      DATA: begin
        if (bit_count == 4'd7)
          next_state = STOP;
        else
          next_state = DATA;
      end
      STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = WAIT_FOR_STOP;
      end
      WAIT_FOR_STOP: begin
        if (in == 1'b1)
          next_state = IDLE;
        else
          next_state = WAIT_FOR_STOP;
      end
    endcase
  end

endmodule