module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

reg [7:0] shift_reg [2:0];

reg [1:0] state;
parameter IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10;

always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    out_bytes <= 24'h0;
    done <= 0;
    shift_reg[0] <= 8'h00;
    shift_reg[1] <= 8'h00;
    shift_reg[2] <= 8'h00;
  end else begin
    case(state)
      IDLE: begin
        if (in[3] == 1) begin
          state <= BYTE1;
          shift_reg[0] <= in;
        end
      end
      BYTE1: begin
        shift_reg[1] <= in;
        state <= BYTE2;
      end
      BYTE2: begin
        shift_reg[2] <= in;
        state <= IDLE;
        out_bytes <= {shift_reg[0], shift_reg[1], shift_reg[2]};
        done <= 1;
      end
    endcase
  end
end

endmodule