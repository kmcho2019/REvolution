module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Define the states
localparam IDLE = 2'd0;
localparam SHIFT_IN = 2'd1;
localparam STOP_BIT = 2'd2;

// Registers
reg [9:0] shift_reg;
reg [1:0] state;

// FSM
always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    shift_reg <= 10'b1111111111;
    done <= 0;
  end else begin
    case (state)
      IDLE: begin
        if (!in && (shift_reg[9:1] == 9'b111111111)) begin
          state <= SHIFT_IN;
          shift_reg <= {shift_reg[8:0], in};
        end
      end
      SHIFT_IN: begin
        shift_reg <= {shift_reg[8:0], in};
        if (shift_reg[9] && (shift_reg[8:1] == 8'b00000000) && !in) begin
          state <= STOP_BIT;
        end
      end
      STOP_BIT: begin
        if (in && (shift_reg[8:1] == 8'b00000000)) begin
          done <= 1;
          state <= IDLE;
        end
      end
    endcase
  end
end

endmodule