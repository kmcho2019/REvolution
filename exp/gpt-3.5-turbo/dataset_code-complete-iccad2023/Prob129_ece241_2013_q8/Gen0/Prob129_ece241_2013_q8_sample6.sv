module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // State definition
  reg [1:0] state, next_state;   // 2-bit state encoding

  // State parameters
  localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

  // State transition logic
  always @ (posedge clk or negedge aresetn) begin
    if (~aresetn) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

  // Output logic
  always @ (*) begin
    z = 0;
    case (state)
      S0: begin
        if (x) begin
          next_state = S1;
        end else begin
          next_state = S0;
        end
      end
      S1: begin
        if (x) begin
          next_state = S1;
        end else begin
          next_state = S2;
        end
      end
      S2: begin
        if (x) begin
          z = 1;   // Detected "101" sequence
          next_state = S1;
        end else begin
          next_state = S0;
        end
      end
    endcase
  end

endmodule