module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output done
);

  // State encoding
  localparam IDLE = 2'b00;
  localparam BYTE1 = 2'b01;
  localparam BYTE2 = 2'b10;

  reg [1:0] state, next_state;
  reg done_reg;

  assign done = done_reg;

  // State register
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done_reg <= 1'b0;
    end else begin
      state <= next_state;
      // done asserted only for one cycle after third byte received
      if (state == BYTE2)
        done_reg <= 1'b1;
      else
        done_reg <= 1'b0;
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      IDLE: begin
        if (in[3] == 1'b1)
          next_state = BYTE1;
        else
          next_state = IDLE;
      end
      BYTE1: begin
        next_state = BYTE2;
      end
      BYTE2: begin
        next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule