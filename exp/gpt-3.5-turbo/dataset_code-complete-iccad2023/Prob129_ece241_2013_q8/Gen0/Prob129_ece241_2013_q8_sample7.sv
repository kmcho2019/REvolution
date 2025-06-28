module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  reg [1:0] state;
  parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

  always @(posedge clk or negedge aresetn) begin
    if (~aresetn)
      state <= S0;
    else begin
      case (state)
        S0: begin
          if (x)
            state <= S1;
        end
        S1: begin
          if (!x)
            state <= S0;
          else
            state <= S2;
        end
        S2: begin
          if (x)
            state <= S1;
          else
            state <= S0;
        end
      endcase
    end
  end

  assign z = (state == S2);

endmodule