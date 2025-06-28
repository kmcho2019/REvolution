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
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= WAIT_FOR_START;
    end else begin
      state <= next_state;
    end
  end

  // Declare output registers
  reg [23:0] out_bytes_reg;
  reg done_reg; // Separate done signal register

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
        // Shift and store incoming bytes properly
        if (out_bytes_reg[15:0] != 16'hxxxx) begin
          out_bytes_reg <= {out_bytes_reg[15:0], in};
        end else begin
          out_bytes_reg <= {out_bytes_reg[7:0], in};
          if (out_bytes_reg[23:0] != 24'hxxxxxxxx) begin
            next_state = DONE;
          end else begin
            next_state = RECEIVING;
          end
        end
      end
      DONE: begin
        next_state = WAIT_FOR_START;
      end
    endcase
  end

  // Generate done signal
  always @* begin
    done_reg = (state == DONE);
  end

  // Assign outputs
  assign out_bytes = done_reg ? out_bytes_reg : 24'hxxxxxxxx;
  assign done = done_reg;

endmodule