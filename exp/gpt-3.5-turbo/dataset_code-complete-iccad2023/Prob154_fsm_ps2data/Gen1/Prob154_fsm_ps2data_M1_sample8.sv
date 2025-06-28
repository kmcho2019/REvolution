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
  reg [7:0] byte_count;

  // FSM logic
  always @* begin
    case (state)
      WAIT_FOR_START: begin
        if (in[3] == 1'b1) begin
          next_state = RECEIVING;
          byte_count <= 0;
        end else begin
          next_state = WAIT_FOR_START;
        end
      end
      RECEIVING: begin
        if (byte_count == 0) begin
          out_bytes_reg[23:16] <= in;
        end else if (byte_count == 1) begin
          out_bytes_reg[15:8] <= in;
        end else if (byte_count == 2) begin
          out_bytes_reg[7:0] <= in;
          next_state = DONE;
        end
        byte_count <= byte_count + 1;
      end
      DONE: begin
        next_state = WAIT_FOR_START;
      end
    endcase
  end

  // Generate done signal (asserted one cycle after the third byte of each message is received)
  reg done_reg;
  always @* begin
    done_reg = (state == DONE);
  end

  // Synchronize output signals
  reg [23:0] out_bytes_sync;
  always @(posedge clk) begin
    if (done_reg) begin
      out_bytes_sync <= out_bytes_reg;
    end
  end

  // Assign output signals
  assign out_bytes = done_reg ? out_bytes_sync : 24'bxxxxxxxxxxxxxxxxxxxxxxxx;
  assign done = done_reg;

endmodule