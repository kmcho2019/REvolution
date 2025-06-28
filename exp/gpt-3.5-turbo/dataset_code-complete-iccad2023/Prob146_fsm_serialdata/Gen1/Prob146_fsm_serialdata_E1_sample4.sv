module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter START_BIT = 2'b01;
parameter DATA_BITS = 2'b10;
parameter STOP_BIT = 2'b11;

// Define signals
reg [1:0] state;
reg [3:0] shift_reg;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    shift_reg <= 4'b0000;
    done <= 0;
    out_byte <= 8'b0;
  end
  else begin
    case (state)
      IDLE: begin
        if (in == 1'b0) begin
          state <= START_BIT;
        end
      end
      
      START_BIT: begin
        shift_reg <= {shift_reg[2:0], in};
        if (shift_reg == 5'b00001) begin
          state <= DATA_BITS;
        end
      end
      
      DATA_BITS: begin
        shift_reg <= {shift_reg[2:0], in};
        out_byte <= {out_byte[6:0], in};
        if (shift_reg == 5'b0000111) begin
          state <= STOP_BIT;
        end
      end

      STOP_BIT: begin
        shift_reg <= {shift_reg[2:0], in};
        if (shift_reg[3] == 1'b1) begin
          done <= 1;
          state <= IDLE;
        end
      end
    endcase
  end
end

endmodule