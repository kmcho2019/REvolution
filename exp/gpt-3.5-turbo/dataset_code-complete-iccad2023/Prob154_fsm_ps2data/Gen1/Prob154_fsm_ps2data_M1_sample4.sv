module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output [23:0] out_bytes,
  output done
);

  // Define states
  parameter WAIT_FOR_START = 2'b00;
  parameter RECEIVING = 2'b01;
  parameter DONE = 2'b10;

  // Declare state and next_state signals
  reg [1:0] state, next_state;
  
  // Output register for the 24-bit message
  reg [23:0] out_bytes_reg;

  // FSM logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= WAIT_FOR_START;
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    next_state = state;
    out_bytes_reg = out_bytes_reg; // Default value, reassign each cycle

    case (state)
      WAIT_FOR_START: begin
        if (in[3]) begin
          next_state = RECEIVING;
        end
      end
      RECEIVING: begin
        out_bytes_reg[23:16] <= in;
        if (out_bytes_reg[7:0] != 8'hxx) begin
          next_state = DONE;
        end
      end
      DONE: begin
        next_state = WAIT_FOR_START;
      end
    endcase
  end

  // Generate done signal
  assign done = (state == DONE);

  // Assign output bytes
  assign out_bytes = done ? out_bytes_reg : 24'hxxxxxx;

endmodule