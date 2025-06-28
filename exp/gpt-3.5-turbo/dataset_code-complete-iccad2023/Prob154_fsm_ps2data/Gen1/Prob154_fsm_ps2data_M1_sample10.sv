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

  // Declare output register
  reg [23:0] out_bytes_reg;

  // FSM logic
  always @* begin
    case (state)
      WAIT_FOR_START: begin
        if (in[3]) begin
          next_state = RECEIVING;
        end else begin
          next_state = WAIT_FOR_START;
        end
      end
      RECEIVING: begin
        // Shift and collect incoming bytes
        if (in[3]) begin
          out_bytes_reg[23:16] <= in;
        end else if (out_bytes_reg[23:16] != 8'hxx && out_bytes_reg[15:8] == 8'hxx) begin
          out_bytes_reg[15:8] <= in;
        end else if (out_bytes_reg[15:8] != 8'hxx && out_bytes_reg[7:0] == 8'hxx) begin
          out_bytes_reg[7:0] <= in;
          next_state = DONE;
        end else begin
          next_state = RECEIVING;
        end
      end
      DONE: begin
        // Output the message and reset for the next cycle
        next_state = WAIT_FOR_START;
      end
    endcase
  end

  // Generate done signal
  reg done_internal;
  always @* begin
    done_internal = (state == DONE);
  end

  // Synchronize done signal with state transitions
  always @(posedge clk) begin
    done <= done_internal;
    if (reset) begin
      done <= 1'b0;
      out_bytes_reg <= 24'hxxxxxx;
    end else if (done_internal) begin
      out_bytes <= out_bytes_reg;
    end
  end

endmodule