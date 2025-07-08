module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // State encoding
  localparam IDLE = 2'b00;
  localparam BYTE1 = 2'b01;
  localparam BYTE2 = 2'b10;

  reg [1:0] state, next_state;
  reg [23:0] byte_buffer;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 0;
      byte_buffer <= 0;
    end else begin
      state <= next_state;
      
      case (state)
        IDLE: begin
          done <= 0;
          if (in[3]) begin
            byte_buffer <= {byte_buffer[15:0], in};
          end
        end
        BYTE1: begin
          done <= 0;
          byte_buffer <= {byte_buffer[15:0], in};
        end
        BYTE2: begin
          done <= 1;
          byte_buffer <= {byte_buffer[15:0], in};
          out_bytes <= {byte_buffer[15:0], in};
        end
        default: begin
          done <= 0;
        end
      endcase
    end
  end

  always @(*) begin
    case (state)
      IDLE: next_state = (in[3]) ? BYTE1 : IDLE;
      BYTE1: next_state = BYTE2;
      BYTE2: next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

endmodule