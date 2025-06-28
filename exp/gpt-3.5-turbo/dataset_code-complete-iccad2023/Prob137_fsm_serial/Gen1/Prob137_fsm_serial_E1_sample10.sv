module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // Define states
  parameter IDLE = 2'b00;
  parameter DATA_BITS = 2'b01;
  parameter DETECT_BYTE = 2'b10;

  // Define internal signals
  reg [1:0] state, next_state;
  reg [2:0] count;
  reg [7:0] data;

  // FSM
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      count <= 0;
      data <= 8'b0;
      done <= 0;
    end else begin
      state <= next_state;
    end
  end

  // State transitions and data processing
  always @(*) begin
    next_state = state;
    done = 0;

    case (state)
      IDLE: begin
        if (in == 1'b0) begin
          next_state = DATA_BITS;
          count <= 0;
          data <= 8'b0;
        end
      end
      DATA_BITS: begin
        if (count < 8) begin
          count <= count + 1;
          data <= {data[6:0], in};
          next_state = (count == 7) ? DETECT_BYTE : DATA_BITS;
        end
      end
      DETECT_BYTE: begin
        if (in == 1'b1) begin
          next_state = IDLE;
          done = 1;
        end else begin
          next_state = DATA_BITS;
          count <= 0;
          data <= 8'b0;
        end
      end
    endcase
  end

endmodule