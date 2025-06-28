module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter BYTE3 = 2'b11;

// Define state reg and next state reg
reg [1:0] state_reg, next_state_reg;

// State transition and output logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state_reg <= IDLE;
    done <= 0;
  end else begin
    state_reg <= next_state_reg;
    done <= 0;
  end
end

always @* begin
  case (state_reg)
    IDLE: begin
      if (in[3] == 1) begin
        next_state_reg = BYTE1;
      end else begin
        next_state_reg = IDLE;
      end
    end
    BYTE1: begin
      if (in[3] == 1) begin
        next_state_reg = BYTE2;
      end else begin
        next_state_reg = IDLE;
      end
    end
    BYTE2: begin
      if (in[3] == 1) begin
        next_state_reg = BYTE3;
      end else begin
        next_state_reg = IDLE;
      end
    end
    BYTE3: begin
      next_state_reg = IDLE;
      done = 1;
    end
    default: begin
      next_state_reg = IDLE;
    end
  endcase
end

endmodule