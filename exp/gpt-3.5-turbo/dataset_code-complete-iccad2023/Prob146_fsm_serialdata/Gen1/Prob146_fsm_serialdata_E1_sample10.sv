module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

// State definition
parameter IDLE = 2'd0;
parameter DETECT_START = 2'd1;
parameter DATA_RECEIVE = 2'd2;
parameter DATA_VERIFY = 2'd3;
parameter DETECT_STOP = 2'd4;

reg [1:0] state;
reg [7:0] data_byte;
reg [2:0] bit_counter;
reg start_detected;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    data_byte <= 8'b0;
    bit_counter <= 3'b0;
    start_detected <= 1'b0;
    out_byte <= 8'b0;
    done <= 1'b0;
  end else begin
    case (state)
      IDLE: begin
        if (!in) begin
          state <= DETECT_START;
          start_detected <= 1'b0;
          bit_counter <= 3'b0;
        end
      end
      DETECT_START: begin
        if (in == 1'b0) begin
          state <= DATA_RECEIVE;
        end
      end
      DATA_RECEIVE: begin
        data_byte <= {data_byte[6:0], in};
        bit_counter <= bit_counter + 1;
        if (bit_counter == 3'b111) begin
          state <= DATA_VERIFY;
        end
      end
      DATA_VERIFY: begin
        if (in == 1'b1 && !start_detected) begin
          state <= DETECT_START;
          start_detected <= 1'b1;
        end
        else if (in == 1'b1 && start_detected) begin
          state <= DETECT_STOP;
        end
        else begin
          state <= DATA_RECEIVE;
        end
      end
      DETECT_STOP: begin
        if (in == 1'b1) begin
          out_byte <= data_byte;
          done <= 1'b1;
          state <= IDLE;
        end else begin
          state <= DETECT_START;
        end
      end
    endcase
  end
end

endmodule