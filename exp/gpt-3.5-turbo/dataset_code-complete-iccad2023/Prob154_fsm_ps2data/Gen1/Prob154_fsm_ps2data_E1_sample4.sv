module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output [23:0] out_bytes,
  output reg done
);

reg [23:0] out_bytes_reg;
reg [3:0] byte_count;
reg [7:0] last_byte;

always @(posedge clk) begin
  if (reset) begin
    out_bytes_reg <= 24'h0;
    done <= 0;
    byte_count <= 4'd0;
    last_byte <= 8'h00;
  end else begin
    if (byte_count == 4'd0 && in[3] == 1) begin
      out_bytes_reg[23:16] <= in;
      byte_count <= byte_count + 1;
      last_byte <= in;
    end else if (byte_count > 4'd0 && byte_count < 4'd3) begin
      out_bytes_reg[(byte_count-1)*8 +: 8] <= in;
      byte_count <= byte_count + 1;
      last_byte <= in;
      if (byte_count == 4'd3) begin
        out_bytes <= out_bytes_reg;
        done <= 1;
      end
    end else if (byte_count == 4'd3) begin
      out_bytes_reg <= {last_byte, in[7:4]}; // Shift previous last byte
      byte_count <= byte_count + 1;
      last_byte <= in;
    end else begin
      byte_count <= 4'd0;
    end
  end
end

endmodule