module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  typedef enum logic [1:0] {
    IDLE = 2'b00,
    START = 2'b01,
    DATA = 2'b10,
    STOP = 2'b11
  } state_t;
  
  state_t state, next_state;
  
  reg [2:0] bit_count;   // count 0 to 7 for data bits
  reg [7:0] data_shift;  // shift register for data bits
  
  // Sequential state and counters update
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      data_shift <= 8'd0;
      out_byte <= 8'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      
      // Default done low, will assert when needed below
      done <= 1'b0;
      
      case (state)
        IDLE: begin
          // waiting for start bit 0
          bit_count <= 0;
          data_shift <= 8'd0;
        end
        START: begin
          // Just detected start bit, prepare to receive data bits
          bit_count <= 0;
          data_shift <= 8'd0;
        end
        DATA: begin
          // Shift in LSB first
          data_shift <= {in, data_shift[7:1]};
          bit_count <= bit_count + 1;
        end
        STOP: begin
          // stop bit verification handled in combinational below
        end
      endcase
      
      // On STOP state and stop bit correct or after error correction
      if (state == STOP) begin
        if (in == 1'b1) begin
          // Stop bit received correctly or after waiting for correct stop bit
          out_byte <= data_shift;
          done <= 1'b1;
          bit_count <= 0;
          data_shift <= 8'd0;
        end
      end
    end
  end
  
  // Combinational logic for next state
  always @(*) begin
    case(state)
      IDLE: begin
        if (in == 1'b0) 
          next_state = START; // detected start bit
        else
          next_state = IDLE;
      end
      START: begin
        next_state = DATA; // start receiving data bits
      end
      DATA: begin
        if (bit_count == 3'd7)
          next_state = STOP; // after receiving 8 bits
        else
          next_state = DATA;
      end
      STOP: begin
        if (in == 1'b1) 
          next_state = IDLE; // stop bit correct, go back to idle
        else
          next_state = STOP; // wait here until stop bit is 1
      end
      default: next_state = IDLE;
    endcase
  end
  
endmodule