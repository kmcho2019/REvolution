module TopModule (
  input clk,
  input slowena,
  input reset,
  output reg [3:0] q
);

  // Define internal state
  reg [3:0] state;

  // State machine to control counter based on slowena
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state <= 4'b0000; // Reset state to 0 when reset signal is high
    end else begin
      case (state)
        4'b0000: begin // State 0
          if (slowena) begin
            state <= 4'b0001;
          end
        end
        4'b0001: begin // State 1
          if (slowena) begin
            state <= 4'b0010;
          end
        end
        4'b0010: begin // State 2
          if (slowena) begin
            state <= 4'b0011;
          end
        end
        4'b0011: begin // State 3
          if (slowena) begin
            state <= 4'b0100;
          end
        end
        4'b0100: begin // State 4
          if (slowena) begin
            state <= 4'b0101;
          end
        end
        4'b0101: begin // State 5
          if (slowena) begin
            state <= 4'b0110;
          end
        end
        4'b0110: begin // State 6
          if (slowena) begin
            state <= 4'b0111;
          end
        end
        4'b0111: begin // State 7
          if (slowena) begin
            state <= 4'b1000;
          end
        end
        4'b1000: begin // State 8
          if (slowena) begin
            state <= 4'b1001;
          end
        end
        4'b1001: begin // State 9
          if (slowena) begin
            state <= 4'b0000; // Reset to 0 if slowena is high in State 9
          end
        end
      endcase
    end
  end

  // Output the current state
  always @ (posedge clk) begin
    q <= state;
  end

endmodule