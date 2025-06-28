module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  reg [1:0] byte_count;

  always @ (posedge clk) begin
    if (reset || byte_count == 2) begin
      byte_count <= 2'b00;
      out_bytes <= 24'hxxxxxx;
      done <= 0;
    end 
    else if (in[3] == 1) begin
      case(byte_count)
        2'b00: out_bytes[23:16] <= in;
        2'b01: out_bytes[15:8] <= in;
        2'b10: begin
          out_bytes[7:0] <= in;
          done <= 1;
          byte_count <= 2'b11;
        end
      endcase
      byte_count <= byte_count + 1;
    end
  end
endmodule