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
  always @(posedge clk) begin
    if (reset) begin
      state <= WAIT_FOR_START;
    end else begin
      state <= next_state;
    end
  end

  // Declare output registers
  reg [23:0] out_bytes_reg;
  reg [1:0] byte_count;

  // FSM logic
  always @* begin
    next_state = state; // Default to current state

    case (state)
      WAIT_FOR_START: begin
        if (in[3]) begin
          next_state = RECEIVING;
          byte_count <= 0;
        end
      end
      RECEIVING: begin
        // Shift and collect incoming bytes
        byte_count <= byte_count + 1;
        case (byte_count)
          1: out_bytes_reg[23:16] <= in;
          2: out_bytes_reg[15:8] <= in;
          3: begin
            out_bytes_reg[7:0] <= in;
            next_state = DONE;
          end
        endcase
      end
      DONE: begin
        // Output the message and return to WAIT_FOR_START
        out_bytes_reg <= next_state == DONE ? out_bytes_reg : 24'hxxxxxx;
        byte_count <= 0;
        next_state = WAIT_FOR_START;
      end
    endcase
  end

  // Generate done signal
  assign done = (state == DONE);

  // Output combined bytes only when done
  assign out_bytes = done ? out_bytes_reg : 24'hxxxxxx;

endmodule