module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

localparam START_BIT = 1'b0;
localparam STOP_BIT = 1'b1;
localparam DATA_BITS = 8;

reg [2:0] shift_reg;
reg [2:0] data_reg;
reg receiving;
reg [3:0] state;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    done <= 0;
    shift_reg <= 3'b000;
    data_reg <= 3'b000;
    state <= 4'b0000;
    receiving <= 0;
  end
  else begin
    case(state)
      4'b0000: begin // IDLE state
        if (in == START_BIT) begin
          shift_reg <= {shift_reg[1:0], in};
          state <= 4'b0001;
        end
      end
      4'b0001: begin // START_BIT received
        if (receiving < DATA_BITS) begin
          shift_reg <= {shift_reg[1:0], in};
          data_reg <= {data_reg[2:0], in};
          receiving <= receiving + 1;
        end
        else if (in == STOP_BIT) begin
          shift_reg <= {shift_reg[1:0], in};
          state <= 4'b0010;
        end
        else begin
          state <= 4'b0000; // Restart receiving
        end
      end
      4'b0010: begin // STOP_BIT received
        if (in == STOP_BIT) begin
          shift_reg <= {shift_reg[1:0], in};
          done <= 1;
          state <= 4'b0000;
        end
        else begin
          state <= 4'b0000; // Restart receiving
        end
      end
    endcase
  end
end

endmodule