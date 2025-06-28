module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

reg [2:0] counter;
reg [3:0] data_bits;
reg [1:0] state;

parameter IDLE = 2'b00, RECEIVING = 2'b01, STOP_CHECK = 2'b10;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    counter <= 0;
    data_bits <= 0;
    done <= 0;
  end else begin
    case (state)
      IDLE: begin
        if (in == 0) begin
          state <= RECEIVING;
          counter <= 0;
          data_bits <= 0;
        end
      end
      RECEIVING: begin
        if (counter < 8) begin
          data_bits <= {in, data_bits[3:1]}; // Shift in the received bit
          counter <= counter + 1;
        end else begin
          state <= STOP_CHECK;
          counter <= 0;
        end
      end
      STOP_CHECK: begin
        if (in == 1) begin
          done <= 1;
          state <= IDLE;
        end else begin
          state <= IDLE;
        end
      end
      default: state <= IDLE;
    endcase
  end
end

endmodule