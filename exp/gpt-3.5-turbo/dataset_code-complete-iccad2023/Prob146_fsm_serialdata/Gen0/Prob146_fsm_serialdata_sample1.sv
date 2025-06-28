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
  parameter DATA_BIT = 2'b10;
  parameter STOP_BIT = 2'b11;
  
  // Define outputs
  reg [7:0] out_byte_reg;
  reg [1:0] state, next_state;

  // FSM
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      out_byte_reg <= 8'b0;
    end 
    else begin
      state <= next_state;
      out_byte_reg <= (next_state == STOP_BIT) ? out_byte_reg : out_byte_reg; // Output data only when stop bit is received
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;

    case(state)
      IDLE: begin
        if (in == 0) begin
          next_state = START_BIT; // Start bit detected
        end
      end
      START_BIT: begin
        next_state = DATA_BIT; // Move to data bit phase
      end
      DATA_BIT: begin
        out_byte_reg <= {out_byte_reg[6:0], in}; // Collect data bits
        next_state = (out_byte_reg[7:0] == 8'b10101010) ? STOP_BIT : DATA_BIT; // Check for stop bit
      end
      STOP_BIT: begin
        next_state = IDLE; // Wait for next byte to start
      end
    endcase
  end

  // Output assignment
  assign out_byte = out_byte_reg;
  assign done = (next_state == STOP_BIT);

endmodule