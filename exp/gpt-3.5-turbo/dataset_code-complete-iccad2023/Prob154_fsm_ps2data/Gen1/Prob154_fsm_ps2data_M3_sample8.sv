module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // Define states
  parameter IDLE = 2'b00;
  parameter RECEIVING = 2'b01;

  // State and next_state signals
  reg [1:0] state, next_state;

  always @* begin
    case (state)
      IDLE: begin
        if (reset) begin
          next_state = IDLE;
        end else if (in[3]) begin
          next_state = RECEIVING;
        end else begin
          next_state = IDLE;
        end
      end
      RECEIVING: begin
        if (reset || state == IDLE) begin
          next_state = IDLE;
        end else if (out_bytes[15:8] == 8'h00) begin
          next_state = RECEIVING;
        end else begin
          next_state = IDLE;
        end
      end
    endcase
  end

  // FSM state transition and data processing
  always @(posedge clk) begin
    state <= next_state;
    case (state)
      IDLE: begin
        if (in[3]) begin
          out_bytes <= {24'hxx, in}; // Start new message
        end
      end
      RECEIVING: begin
        if (out_bytes[15:8] != 8'h00 && out_bytes[7:0] != 8'h00) begin
          done <= 1; // Message complete
        end
        if (out_bytes[15:8] != 8'h00) begin
          out_bytes <= {out_bytes[15:0], in};
        end
      end
    endcase
  end

endmodule