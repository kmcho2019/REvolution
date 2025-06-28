module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);
  
  reg [1:0] state;
  reg [7:0] byte_count;
  reg [23:0] message;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00;
      byte_count <= 8'd0;
      message <= 24'd0;
      out_bytes <= 24'd0;
      done <= 0;
    end
    else begin
      case(state)
        2'b00: begin // State 0 - Looking for start of message
          if (in[3] == 1) begin
            state <= 2'b01;
            byte_count <= 8'd1;
            message <= {in, message[23:8]}; // Shift in the first byte
          end
        end
        2'b01: begin // State 1 - Accumulating message
          message <= {in, message[23:8]}; // Shift in the byte
          byte_count <= byte_count + 1;
          if (byte_count == 8'd3) begin
            out_bytes <= message;
            done <= 1;
            state <= 2'b00;
          end
        end
      endcase
    end
  end

endmodule