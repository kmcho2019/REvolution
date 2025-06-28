module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output [23:0] out_bytes,
  output done
);

  reg [1:0] state;
  reg [7:0] byte1, byte2, byte3;
  reg [23:0] out_bytes_reg;
  assign out_bytes = done ? out_bytes_reg : 24'b0;

  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00;
      out_bytes_reg <= 24'b0;
    end else begin
      case (state)
        2'b00: begin // IDLE
          if (in[3]) begin
            byte1 <= in;
            state <= 2'b01; // BYTE1
          end
        end
        2'b01: begin // BYTE1
          byte2 <= in;
          state <= 2'b10; // BYTE2
        end
        2'b10: begin // BYTE2
          byte3 <= in;
          state <= 2'b11; // BYTE3
        end
        2'b11: begin // BYTE3
          out_bytes_reg <= {byte1, byte2, byte3};
          state <= 2'b00; // IDLE
        end
      endcase
    end
  end

  assign done = (state == 2'b11);

endmodule