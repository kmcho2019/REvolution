module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output [23:0] out_bytes,
  output done
);

  // Define states
  parameter WAIT_FOR_START = 2'b00;
  parameter COLLECTING_BYTES = 2'b01;
  parameter MESSAGE_DONE = 2'b10;

  // Declare state and next_state signals
  reg [1:0] state, next_state;
  always @(posedge clk) begin
    if (reset) begin
      state <= WAIT_FOR_START;
    end else begin
      state <= next_state;
    end
  end

  // Declare registers to store message bytes
  reg [7:0] byte1, byte2, byte3;

  // Declare output register
  reg [23:0] out_bytes_reg;

  // FSM logic
  always @* begin
    case (state)
      WAIT_FOR_START: begin
        if (in[3] == 1) begin
          byte1 <= in;
          next_state = COLLECTING_BYTES;
        end else begin
          next_state = WAIT_FOR_START;
        end
      end
      COLLECTING_BYTES: begin
        byte2 <= in;
        next_state = (byte1 != 8'hxx && byte2 != 8'hxx) ? MESSAGE_DONE : COLLECTING_BYTES;
      end
      MESSAGE_DONE: begin
        byte3 <= in;
        out_bytes_reg = {byte1, byte2, byte3};
        next_state = WAIT_FOR_START;
      end
    endcase
  end

  // Generate done signal
  assign done = (state == MESSAGE_DONE);

  // Assign output bytes appropriately
  assign out_bytes = done ? out_bytes_reg : 24'hxxxxxx;

endmodule