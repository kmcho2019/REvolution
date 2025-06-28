module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // Define states
  parameter SEARCH_START = 2'b00;
  parameter COLLECT_BYTES = 2'b01;
  reg [1:0] state, next_state;

  always @ (posedge clk) begin
    if (reset) begin
      state <= SEARCH_START;
      done <= 0;
      out_bytes <= 24'hxxxxxx;
    end
    else begin
      state <= next_state;
      case (state)
        SEARCH_START: begin
          if (in[3] == 1) begin
            next_state <= COLLECT_BYTES;
          end
          else begin
            next_state <= SEARCH_START;
          end
        end
        COLLECT_BYTES: begin
          out_bytes[23:16] <= in;
          if (out_bytes[15:0] != 16'hxxxx) begin
            out_bytes[15:8] <= in;
            if (out_bytes[7:0] != 8'hxx) begin
              out_bytes[7:0] <= in;
              done <= 1;
              out_bytes <= {out_bytes[23:16], out_bytes[15:8], out_bytes[7:0]};
              next_state <= SEARCH_START;
            end
            else begin
              next_state <= COLLECT_BYTES;
            end
          end
          else begin
            next_state <= COLLECT_BYTES;
          end
        end
      endcase
    end
  end

endmodule