module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;

  reg [1:0] state, next_state;

  // Mealy type FSM logic for sequence detection
  always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
      state <= S0;
      z <= 0;
    end else begin
      state <= next_state;
    end
  end

  always @(*) begin
    next_state = state;
    z = 0;

    case (state)
      S0: begin
        if (x) begin
          next_state = S1;
        end
      end
      S1: begin
        if (x) begin
          next_state = S2;
        end else begin
          next_state = S0;
        end
      end
      S2: begin
        if (x) begin
          z = 1;
        end
        next_state = S1;
      end
    endcase
  end

endmodule