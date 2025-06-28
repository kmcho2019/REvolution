module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

// State definition
parameter IDLE = 2'd0;
parameter START_BIT = 2'd1;
parameter DATA = 2'd2;
parameter STOP_BIT = 2'd3;

reg [1:0] state;
reg [7:0] data;
reg [2:0] bit_count;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    data <= 0;
    bit_count <= 0;
    out_byte <= 8'b0;
    done <= 0;
  end else begin
    case (state)
      IDLE: begin
        if (!in)
          state <= START_BIT;
      end
      START_BIT: begin
        state <= DATA;
      end
      DATA: begin
        if (bit_count < 8) begin
          data <= {data[6:0], in};
          bit_count <= bit_count + 1;
        end else begin
          state <= STOP_BIT;
        end
      end
      STOP_BIT: begin
        if (in) begin
          out_byte <= data;
          done <= 1;
          state <= IDLE;
        end
      end
    endcase
  end
end

endmodule