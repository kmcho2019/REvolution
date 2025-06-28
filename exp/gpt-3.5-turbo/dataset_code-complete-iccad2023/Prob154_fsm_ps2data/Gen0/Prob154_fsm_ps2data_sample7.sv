module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

// Define states
parameter IDLE = 2'b00, FIRST_BYTE = 2'b01, SECOND_BYTE = 2'b10, THIRD_BYTE = 2'b11;
reg [1:0] state, next_state;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
    out_bytes <= 24'h000000;
    byte1 <= 8'h00;
    byte2 <= 8'h00;
    byte3 <= 8'h00;
  end else begin
    state <= next_state;
    case(state)
      IDLE: begin
        if (in[3] == 1) begin
          next_state = FIRST_BYTE;
          byte1 <= in;
        end else begin
          next_state = IDLE;
        end
      end
      FIRST_BYTE: begin
        byte2 <= in;
        next_state = SECOND_BYTE;
      end
      SECOND_BYTE: begin
        byte3 <= in;
        next_state = THIRD_BYTE;
      end
      THIRD_BYTE: begin
        out_bytes = {byte1, byte2, byte3};
        done <= 1;
        next_state = IDLE;
      end
    endcase
  end
end

endmodule