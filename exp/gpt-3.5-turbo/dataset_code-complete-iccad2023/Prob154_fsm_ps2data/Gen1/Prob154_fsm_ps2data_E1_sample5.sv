module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter RECEIVING = 2'b01;
reg [1:0] state, next_state;

// Define shift register for byte alignment
reg [23:0] shift_reg;

always @ (posedge clk) begin
  if (reset) begin // Reset
    state <= IDLE;
    done <= 0;
  end
  else begin
    state <= next_state;
    case (state)
      IDLE: begin
        if (in[3] == 1) begin
          shift_reg <= {in, shift_reg[23:8]}; // Shift in new byte
          next_state <= RECEIVING;
          done <= 0;
        end
        else begin
          shift_reg <= {8'h00, shift_reg[23:8]}; // Shift in 0 if start byte not found
          next_state <= IDLE;
        end
      end
      RECEIVING: begin
        shift_reg <= {in, shift_reg[23:8]}; // Shift in new byte
        if (shift_reg[23:16] != 8'h00 && shift_reg[15:8] != 8'h00 && shift_reg[7:0] != 8'h00) begin
          out_bytes <= shift_reg[23:0]; // Extract message when all bytes received
          done <= 1;
          next_state <= IDLE;
        end
        else
          next_state <= RECEIVING;
      end
    endcase
  end
end

endmodule