module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output [23:0] out_bytes,
  output reg done
);

  reg [1:0] state;
  reg [7:0] byte1, byte2, byte3;
  
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00; // IDLE state
    end else begin
      case (state)
        2'b00: begin // IDLE state
          byte1 <= 8'b0;
          if (in[3] == 1) begin
            state <= 2'b01; // BYTE_1 state
            byte1 <= in;
          end
        end
        2'b01: begin // BYTE_1 state
          byte2 <= in;
          state <= 2'b10; // BYTE_2 state
        end
        2'b10: begin // BYTE_2 state
          byte3 <= in;
          done <= 1;
          state <= 2'b00; // IDLE state
        end
      endcase
    end
  end

  always @* begin
    case(state)
      2'b00: out_bytes = 24'bxxxxxxxxxxxxxxxxxxxxxxxx; // don't care
      2'b01: out_bytes = {byte1, 16'bxxxxxxxxxxxxxxxx}; // only byte 1 valid
      2'b10: out_bytes = {byte1, byte2, 8'b00000000}; // bytes 1 and 2 valid
    endcase
  end

endmodule