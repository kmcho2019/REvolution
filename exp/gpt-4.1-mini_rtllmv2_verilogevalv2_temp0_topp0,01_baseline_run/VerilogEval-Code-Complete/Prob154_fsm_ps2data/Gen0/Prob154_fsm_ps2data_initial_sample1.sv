module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // State encoding
  localparam IDLE  = 2'd0;
  localparam BYTE2 = 2'd1;
  localparam BYTE3 = 2'd2;

  reg [1:0] state, next_state;

  // Sequential state and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      out_bytes <= 24'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0; // default done low, set high only in BYTE3 when done
      case (state)
        IDLE: begin
          if (in[3]) begin
            out_bytes[23:16] <= in; // first byte
            next_state <= BYTE2;
          end else begin
            next_state <= IDLE;
          end
        end
        BYTE2: begin
          out_bytes[15:8] <= in; // second byte
          next_state <= BYTE3;
        end
        BYTE3: begin
          out_bytes[7:0] <= in; // third byte
          done <= 1'b1;         // signal done this cycle
          next_state <= IDLE;
        end
        default: begin
          next_state <= IDLE;
        end
      endcase
    end
  end

endmodule