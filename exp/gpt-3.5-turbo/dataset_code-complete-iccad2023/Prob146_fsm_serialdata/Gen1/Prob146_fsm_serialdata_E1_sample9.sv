module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // Define states
  parameter IDLE = 2'b00;
  parameter RECEIVING = 2'b01;

  // Define outputs
  reg [1:0] state, next_state;
  reg [7:0] shift_reg;
  reg [2:0] bit_counter;

  // FSM
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      out_byte <= 8'b0;
      shift_reg <= 8'b0;
      bit_counter <= 3'b0;
    end 
    else begin
      state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;

    case(state)
      IDLE: begin
        if (in == 0) begin
          next_state = RECEIVING; // Start receiving bits
          shift_reg <= 8'b0; // Clear shift register
          bit_counter <= 3'b0; // Reset bit counter
        end
      end
      RECEIVING: begin
        shift_reg <= {shift_reg[6:0], in}; // Shift in incoming bit
        bit_counter <= bit_counter + 1; // Increment bit counter

        if (bit_counter == 3'b101) begin // Check for stop bit pattern
          out_byte <= shift_reg[6:0]; // Output received byte
          done <= 1;
          next_state = IDLE; // Return to IDLE state
        end
      end
    endcase
  end

endmodule