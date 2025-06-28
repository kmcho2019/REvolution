module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output [23:0] out_bytes,
  output done
);

  // Define states
  parameter IDLE = 2'b00;
  parameter BYTE1 = 2'b01;
  parameter BYTE2 = 2'b10;
  parameter BYTE3 = 2'b11;

  // Declare state and next_state signals
  reg [1:0] state, next_state;
  
  // Data register to store incoming bytes
  reg [7:0] data_reg;
  
  // Output register for the completed message
  reg [23:0] out_bytes_reg;
  
  // FSM logic
  always @* begin
    next_state = state; // Default to current state
    
    case (state)
      IDLE: begin
        if (reset) begin
          next_state = IDLE;
          data_reg <= 8'b0;
        end else if (in[3]) begin
          data_reg <= in;
          next_state = BYTE1;
        end
      end
      BYTE1: begin
        if (in[3]) begin
          data_reg <= {data_reg[7:0], in};
        end else begin
          next_state = BYTE2;
        end
      end
      BYTE2: begin
        data_reg <= {data_reg[7:0], in};
        if (in[3]) begin
          next_state = BYTE3;
        end
      end
      BYTE3: begin
        if (in[3]) begin
          data_reg <= {data_reg[7:0], in};
          
          // Message completed, update output register and transition to IDLE
          out_bytes_reg <= data_reg;
          next_state = IDLE;
        end
      end
    endcase
  end

  // Update state at posedge of clock
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // Generate done signal
  assign done = (state == BYTE3);

  // Output the message when done is asserted
  assign out_bytes = done ? out_bytes_reg : 24'hxxxxxx;

endmodule