module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  reg [1:0] state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00; // SEARCH state
      done <= 0;
      out_bytes <= 24'd0;
    end
    else begin
      case (state)
        2'b00: begin // SEARCH state
          if (in[3] == 1) begin
            state <= 2'b01; // Move to OUTPUT state
            out_bytes[23:16] <= in;
          end
        end
        2'b01: begin // OUTPUT state
          out_bytes[15:8] <= in;
          state <= 2'b10; // Move to final state
        end
        2'b10: begin
          out_bytes[7:0] <= in;
          done <= 1;
          state <= 2'b00; // Move back to SEARCH state
        end
      endcase
    end
  end

endmodule