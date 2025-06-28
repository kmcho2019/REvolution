module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output wire [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

reg [7:0] shift_reg;
reg [2:0] control;
reg [3:0] delay;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    shift_reg <= 8'b0;
    control <= 3'b0;
    done <= 0;
    counting <= 0;
    delay <= 4'b0;
  end
  else begin
    shift_reg <= {shift_reg[6:0], data};
    case (control)
      3'b000: begin // Check for start pattern 1101
        if (shift_reg == 8'b1101) begin
          control <= 3'b001;
        end
      end
      3'b001: begin // Read in 4 bits to get delay value
        delay <= shift_reg[3:0];
        counting <= 1;
        control <= 3'b010;
      end
      3'b010: begin // Countdown delay in 1000-cycle intervals
        if (counting) begin
          if (delay > 0) begin
            delay <= delay - 1;
          end
          else begin
            done <= 1;
            counting <= 0;
            control <= 3'b011;
          end
        end
      end
      3'b011: begin // Wait for acknowledgment to reset
        if (ack) begin
          control <= 3'b100;
        end
      end
      3'b100: begin // Reset to start pattern check state
        control <= 3'b000;
      end
    endcase
  end
end

assign count = counting ? delay : 4'b0;

endmodule