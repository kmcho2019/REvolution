module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

// State definition
parameter IDLE = 3'd0;
parameter START_BIT = 3'd1;
parameter DATA_BIT_0 = 3'd2;
parameter DATA_BIT_7 = 3'd9;
parameter STOP_BIT = 3'd10;

reg [3:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    out_byte <= 8'b0;
    done <= 0;
  end 
  else begin
    case(state)
      IDLE: begin
        if (in == 1) begin
          state <= START_BIT;
        end
      end
      START_BIT: begin
        if (in == 0) begin
          state <= DATA_BIT_0;
        end
      end
      DATA_BIT_0, DATA_BIT_1, DATA_BIT_2, DATA_BIT_3, DATA_BIT_4, DATA_BIT_5, DATA_BIT_6, DATA_BIT_7: begin
        if (state == DATA_BIT_7) begin
          state <= STOP_BIT;
        end
        else begin
          out_byte <= {out_byte[6:0], in}; // Shift in data bits
          state <= state + 1;
        end
      end
      STOP_BIT: begin
        if (in == 1) begin
          done <= 1;
          state <= IDLE;
        end
      end
    endcase
  end
end

endmodule