module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

reg [7:0] shift_reg [2:0];
reg [1:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 2'b00; // IDLE state
    out_bytes <= 24'b0;
    done <= 0;
    shift_reg[0] <= 8'h00;
    shift_reg[1] <= 8'h00;
    shift_reg[2] <= 8'h00;
  end else begin
    case(state)
      2'b00: begin // IDLE state
        if (in[3] == 1) begin
          shift_reg[0] <= in;
          state <= 2'b01; // Move to BYTE1 state
        end
      end
      2'b01: begin // BYTE1 state
        if (in[3] == 0) begin
          shift_reg[1] <= in;
          state <= 2'b10; // Move to BYTE2 state
        end
      end
      2'b10: begin // BYTE2 state
        if (in[3] == 0) begin
          shift_reg[2] <= in;
          state <= 2'b11; // Move to BYTE3 state
        end
      end
      2'b11: begin // BYTE3 state
        out_bytes <= {shift_reg[0], shift_reg[1], shift_reg[2]};
        done <= 1;
        state <= 2'b00; // Move back to IDLE state
      end
    endcase
  end
end

endmodule