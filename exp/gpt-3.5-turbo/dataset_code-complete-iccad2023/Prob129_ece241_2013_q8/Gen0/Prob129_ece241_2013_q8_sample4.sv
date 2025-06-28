module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  reg [1:0] state, next_state;

  parameter IDLE = 2'b00;
  parameter S0 = 2'b01;
  parameter S1 = 2'b10;

  always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
      state <= IDLE;
      z <= 1'b0;
    end
    else begin
      state <= next_state;
    end
  end

  always @* begin
    next_state = state;
    z = 1'b0;

    case (state)
      IDLE: begin
        if (x)
          next_state = S0;
      end
      S0: begin
        if (x)
          next_state = S0;
        else
          next_state = S1;
      end
      S1: begin
        if (x)
          next_state = S0;
        else begin
          next_state = IDLE;
          z = 1'b1; // Detected "101" sequence
        end
      end
    endcase
  end

endmodule