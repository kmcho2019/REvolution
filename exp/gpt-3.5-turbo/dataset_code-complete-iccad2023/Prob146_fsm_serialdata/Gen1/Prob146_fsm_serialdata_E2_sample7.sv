module TopModule (
  input clk,
  input in,
  input reset,
  output [7:0] out_byte,
  output done
);

  // Define states
  parameter IDLE = 2'b00;
  parameter START_BIT = 2'b01;
  parameter DATA_BITS = 2'b10;
  parameter STOP_BIT = 2'b11;

  // Define outputs
  reg [1:0] state, next_state;
  reg [2:0] data_counter;
  reg [7:0] data_reg;
  reg [7:0] out_byte_reg;
  reg done_reg;

  // FSM
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      next_state <= IDLE;
      data_counter <= 0;
      data_reg <= 8'b0;
      out_byte_reg <= 8'b0;
      done_reg <= 1'b0;
    end 
    else begin
      state <= next_state;
      out_byte_reg <= out_byte_reg;
      done_reg <= (next_state == STOP_BIT) ? 1 : 0;
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;

    case(state)
      IDLE: begin
        if (in == 1'b0) begin
          next_state = START_BIT; // Start bit detected
        end
      end
      START_BIT: begin
        next_state = DATA_BITS; // Move to data bit phase
      end
      DATA_BITS: begin
        if (data_counter < 8) begin
          data_reg[data_counter] <= in;
          data_counter <= data_counter + 1;
          next_state = (data_counter == 7) ? STOP_BIT : DATA_BITS; // Check for stop bit
        end
      end
      STOP_BIT: begin
        if (in == 1'b1) begin
          out_byte_reg <= {data_reg[6:0], data_reg[7]}; // Assemble the byte correctly
          next_state = IDLE; // Wait for next byte to start
        end
      end
    endcase
  end

  // Output assignment
  assign out_byte = out_byte_reg;
  assign done = done_reg;

endmodule