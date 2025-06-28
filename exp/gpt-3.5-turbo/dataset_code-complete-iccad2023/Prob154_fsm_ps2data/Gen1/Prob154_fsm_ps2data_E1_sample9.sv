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

  // Declare counters for byte position
  reg [1:0] byte_count;

  // Declare output register
  reg [23:0] out_bytes_reg;

  // Default assignments
  assign done = 0;
  assign out_bytes = 24'hxxxxxx;

  // FSM logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= WAIT_FOR_START;
      byte_count <= 2'b00;
      out_bytes_reg <= 24'hxxxxxx;
    end else begin
      state <= next_state;
      case (state)
        WAIT_FOR_START: begin
          if (in[3])
            next_state = RECEIVING;
          else
            next_state = WAIT_FOR_START;
        end
        RECEIVING: begin
          if (byte_count == 2'b00) begin
            out_bytes_reg[23:16] <= in;
          end else if (byte_count == 2'b01) begin
            out_bytes_reg[15:8] <= in;
          end else begin
            out_bytes_reg[7:0] <= in;
            next_state = DONE;
          end
          if (byte_count < 2'b11)
            byte_count <= byte_count + 1;
          else
            byte_count <= 2'b00;
        end
        DONE: begin
          // Output the message
          next_state = WAIT_FOR_START;
          byte_count <= 2'b00;
        end
      endcase
    end
  end

  // Generate done signal
  always @* begin
    if (state == DONE) begin
      done = 1;
    end else begin
      done = 0;
    end
  end

  // Output bytes when done
  assign out_bytes = done ? out_bytes_reg : 24'hxxxxxx;

endmodule