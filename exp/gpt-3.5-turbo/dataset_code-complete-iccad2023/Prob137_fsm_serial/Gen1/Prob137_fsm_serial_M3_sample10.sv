module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Enumeration for state encoding
parameter IDLE = 1'b0, RECEIVE = 1'b1;
reg state;
reg [2:0] counter;

always @ (posedge clk) begin
  if (reset) begin
    state <= IDLE;
    counter <= 0;
    done <= 0;
  end
  else begin
    case (state)
      IDLE: begin
        if (in == 0) begin
          state <= RECEIVE;
          counter <= 0;
        end
      end
      RECEIVE: begin
        counter <= counter + 1;
        if (counter == 8) begin
          if (in == 1) begin
            done <= 1;
          end
          state <= IDLE;
        end
      end
    endcase
  end
end

endmodule