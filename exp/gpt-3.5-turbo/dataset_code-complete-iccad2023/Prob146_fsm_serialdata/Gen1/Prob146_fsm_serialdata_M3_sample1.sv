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
reg [2:0] data_counter;
reg [7:0] data;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    data_counter <= 0;
    out_byte <= 8'b0;
    done <= 0;
  end else begin
    case (state)
      IDLE: begin
        if (in == 1'b0) begin
          state <= START_BIT;
          data_counter <= 0;
        end
      end
      START_BIT: begin
        if (in == 1'b1) begin
          state <= IDLE;
        end else begin
          state <= DATA;
          data <= 0;
        end
      end
      DATA: begin
        data <= {data[6:0], in};
        data_counter <= data_counter + 1;
        if (data_counter == 7) begin
          state <= STOP_BIT;
        end
      end
      STOP_BIT: begin
        if (in == 1'b1) begin
          out_byte <= data;
          done <= 1;
          state <= IDLE;
        end
      end
    endcase
  end
end

endmodule