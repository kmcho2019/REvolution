module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  localparam IDLE      = 2'd0;
  localparam RECEIVE   = 2'd1;
  localparam STOP      = 2'd2;
  localparam WAIT_STOP = 2'd3;

  reg [1:0] state, next_state;
  reg [3:0] bit_count; // to count 8 bits (0 to 7)

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 0;
      done <= 0;
    end else begin
      state <= next_state;
      done <= 0; // default done low

      case (state)
        IDLE: begin
          bit_count <= 0;
        end
        RECEIVE: begin
          bit_count <= bit_count + 1;
        end
        STOP: begin
          done <= 1;
          bit_count <= 0;
        end
        WAIT_STOP: begin
          bit_count <= 0;
        end
      endcase
    end
  end

  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (in == 1'b0) // start bit detected
          next_state = RECEIVE;
      end
      RECEIVE: begin
        if (bit_count == 4'd7)
          next_state = STOP;
      end
      STOP: begin
        if (in == 1'b1) // correct stop bit
          next_state = IDLE;
        else
          next_state = WAIT_STOP;
      end
      WAIT_STOP: begin
        if (in == 1'b1) // wait until stop bit detected
          next_state = IDLE;
      end
    endcase
  end

endmodule