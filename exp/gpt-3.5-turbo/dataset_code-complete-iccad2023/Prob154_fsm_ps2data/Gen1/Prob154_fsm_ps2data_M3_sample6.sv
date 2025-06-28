module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // Define states
  parameter IDLE = 2'b00;
  parameter RECEIVING = 2'b01;

  // State register
  reg [1:0] state;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 0;
      out_bytes <= 24'hxxxxxx; // Initialize out_bytes
    end else begin
      case (state)
        IDLE: begin
          if (in[3] == 1) begin
            state <= RECEIVING;
          end
        end
        RECEIVING: begin
          out_bytes[23:16] <= in; // Collect first byte
          if (out_bytes[15:8] != 8'hxx) begin
            out_bytes[15:8] <= in; // Collect second byte
          end
          if (out_bytes[7:0] != 8'hxx) begin
            out_bytes[7:0] <= in; // Collect third byte
            done <= 1;
            state <= IDLE;
          end
        end
      endcase
    end
  end

endmodule