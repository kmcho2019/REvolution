module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  localparam IDLE  = 2'b00,
             BYTE1 = 2'b01,
             BYTE2 = 2'b10,
             BYTE3 = 2'b11;

  reg [1:0] state, next_state;
  reg [7:0] byte1, byte2, byte3;

  // State transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      byte1 <= 8'b0;
      byte2 <= 8'b0;
      byte3 <= 8'b0;
      out_bytes <= 24'b0;
      done <= 1'b0;
    end else begin
      done <= 1'b0; // default done low; asserted only in BYTE3->IDLE transition cycle

      case(state)
        IDLE: begin
          if (in[3]) begin
            byte1 <= in;
            state <= BYTE2;
          end else begin
            state <= IDLE;
          end
        end

        BYTE2: begin
          byte2 <= in;
          state <= BYTE3;
        end

        BYTE3: begin
          byte3 <= in;
          // Assemble output bytes as byte1:byte2:byte3
          out_bytes <= {byte1, byte2, in};
          done <= 1'b1;
          state <= IDLE;
        end

        default: state <= IDLE;
      endcase
    end
  end

endmodule