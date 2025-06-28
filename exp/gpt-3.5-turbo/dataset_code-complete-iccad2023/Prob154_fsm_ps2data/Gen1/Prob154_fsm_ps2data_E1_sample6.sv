module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

// Define FSM states
parameter IDLE = 2'b00;
parameter BYTE1_RCVD = 2'b01;
parameter BYTE2_RCVD = 2'b10;
parameter BYTE3_RCVD = 2'b11;

// Define state register and byte registers
reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

// FSM
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
    byte1 <= 8'h00;
    byte2 <= 8'h00;
    byte3 <= 8'h00;
    out_bytes <= 24'hxxxxxx;
  end
  else begin
    case (state)
      IDLE:
        begin
          if (in[3] == 1) begin
            byte1 <= in;
            state <= BYTE1_RCVD;
          end
        end
      BYTE1_RCVD:
        begin
          byte2 <= in;
          state <= BYTE2_RCVD;
        end
      BYTE2_RCVD:
        begin
          byte3 <= in;
          state <= BYTE3_RCVD;
        end
      BYTE3_RCVD:
        begin
          out_bytes <= {byte1, byte2, byte3};
          done <= 1;
          state <= IDLE;
        end
    endcase
  end
end

endmodule