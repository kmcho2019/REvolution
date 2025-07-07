module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output done
);

  // State encoding
  localparam IDLE  = 2'd0;
  localparam BYTE2 = 2'd1;
  localparam BYTE3 = 2'd2;

  reg [1:0] state, next_state;
  reg done_reg;

  assign done = done_reg;

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset)
      state <= IDLE;
    else
      state <= next_state;
  end

  // Next state logic and done signal generation
  always @(*) begin
    done_reg = 1'b0;
    case(state)
      IDLE: begin
        if (in[3] == 1'b1)
          next_state = BYTE2;
        else
          next_state = IDLE;
      end
      BYTE2: begin
        next_state = BYTE3;
      end
      BYTE3: begin
        done_reg = 1'b1; // signal done after third byte received
        next_state = IDLE;
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end

endmodule