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
  assign out_bytes = done ? out_bytes_reg : 24'hxxxxxx;

  // Logic for shifting and storing incoming bytes
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
        if (out_bytes_reg[15:0] != 16'hxxxx) begin
          out_bytes_reg = {out_bytes_reg[15:0], in};
          if (out_bytes_reg[23:0] == 24'hxx_xxx) begin
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

  // Generate done signal based on the current state
  assign done = (state == DONE);

endmodule