module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // Define states
  reg [1:0] state;
  parameter A = 2'b00;
  parameter B = 2'b01;

  // Shift register to store w values for the last 3 clock cycles
  reg [2:0] w_history = 3'b000;

  // State register
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
    end else begin
      case (state)
        A: begin
          if (s == 1) begin
            state <= B;
          end
        end
        B: begin
          w_history <= {w_history[1:0], w};
        end
      endcase
    end
  end

  // Output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      z <= 0;
    end else begin
      case (state)
        A: begin
          z <= 0;
        end
        B: begin
          if ((w_history[0] & w_history[1]) | (w_history[0] & w_history[2]) | (w_history[1] & w_history[2])) begin
            z <= 1;  // Set z to 1 if exactly 2 clock cycles have w=1 in the 3-clock cycle window
          end else begin
            z <= 0;
          end
        end
      endcase
    end
  end

endmodule