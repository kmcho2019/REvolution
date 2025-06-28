module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output [23:0] out_bytes,
  output reg done
);

reg [23:0] out_bytes_reg;
reg [1:0] state;
parameter IDLE = 2'b00, RECEIVING = 2'b01, DONE = 2'b10;

always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    out_bytes_reg <= 24'h0;
    done <= 0;
  end else begin
    case(state)
      IDLE: begin
        if (in[3] == 1) begin
          state <= RECEIVING;
          out_bytes_reg[23:16] <= in;
        end
      end
      RECEIVING: begin
        out_bytes_reg[15:8] <= out_bytes_reg[23:16];
        out_bytes_reg[7:0] <= in;
        if (in[3] == 0) begin
          state <= DONE;
          done <= 1;
        end
      end
      DONE: begin
        state <= IDLE;
        done <= 0;
        out_bytes <= out_bytes_reg;
        out_bytes_reg <= 24'h0;
      end
    endcase
  end
end

endmodule