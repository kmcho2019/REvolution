module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
  reg [1:0] state, next_state;

  always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
      state <= S0;
      z <= 1'b0;
    end
    else begin
      state <= next_state;
      z <= (state == S2) ? 1'b1 : 1'b0; // Assert z when "101" is detected
    end
  end

  always @(*) begin
    case (state)
      S0: begin // Check for "1"
        next_state = (x == 1'b1) ? S1 : S0;
      end
      S1: begin // Check for "0"
        next_state = (x == 1'b0) ? S2 : S0;
      end
      S2: begin // Check for "1"
        next_state = (x == 1'b1) ? S1 : S0;
      end
      default: next_state = S0;
    endcase
  end

endmodule