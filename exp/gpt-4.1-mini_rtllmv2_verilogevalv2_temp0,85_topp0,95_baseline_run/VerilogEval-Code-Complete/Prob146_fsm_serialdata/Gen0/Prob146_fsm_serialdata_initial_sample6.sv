module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);
  
  // FSM states
  typedef enum logic [1:0] {
    IDLE = 2'b00,
    RECEIVE = 2'b01,
    STOP_BIT = 2'b10
  } state_t;
  
  state_t state, next_state;
  
  reg [3:0] bit_count;  // counts 0 to 7 for data bits
  reg [7:0] shift_reg;
  
  // State register and synchronous reset
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      shift_reg <= 0;
      out_byte <= 0;
      done <= 0;
    end else begin
      state <= next_state;
      done <= 0;  // done is one cycle pulse
      
      case(state)
        IDLE: begin
          if (in == 0) begin
            // start bit detected
            bit_count <= 0;
            shift_reg <= 0;
          end
        end
        
        RECEIVE: begin
          // shift in LSB first on each clock
          shift_reg[bit_count] <= in;
          bit_count <= bit_count + 1;
        end
        
        STOP_BIT: begin
          if (in == 1) begin
            // valid stop bit
            out_byte <= shift_reg;
            done <= 1;
          end
        end
      endcase
    end
  end
  
  // Next state logic
  always @(*) begin
    case(state)
      IDLE: begin
        if (in == 0) 
          next_state = RECEIVE;
        else
          next_state = IDLE;
      end
      
      RECEIVE: begin
        if (bit_count == 8)
          next_state = STOP_BIT;
        else
          next_state = RECEIVE;
      end
      
      STOP_BIT: begin
        if (in == 1)
          next_state = IDLE;  // good stop bit, ready for next start bit
        else
          next_state = STOP_BIT;  // wait until stop bit detected
      end
      
      default: next_state = IDLE;
    endcase
  end

endmodule