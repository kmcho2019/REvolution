module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  // State encoding
  localparam WAIT_FOR_START = 2'd0;
  localparam BYTE_2         = 2'd1;
  localparam BYTE_3         = 2'd2;

  reg [1:0] state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= WAIT_FOR_START;
      done <= 1'b0;
    end else begin
      state <= next_state;
      // done is asserted only in cycle after receiving 3rd byte
      done <= (state == BYTE_3);
    end
  end

  always @(*) begin
    case (state)
      WAIT_FOR_START: begin
        if (in[3] == 1'b1)
          next_state = BYTE_2;
        else
          next_state = WAIT_FOR_START;
      end
      BYTE_2: begin
        next_state = BYTE_3;
      end
      BYTE_3: begin
        next_state = WAIT_FOR_START;
      end
      default: next_state = WAIT_FOR_START;
    endcase
  end

endmodule