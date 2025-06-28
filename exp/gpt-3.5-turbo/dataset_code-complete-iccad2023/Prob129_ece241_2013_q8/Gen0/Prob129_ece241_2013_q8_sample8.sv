module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // Define the states
  reg [1:0] state, next_state;

  // State parameter
  parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
  
  // State register
  always @(posedge clk or negedge areset_n) begin
    if (~aresetn) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

  // State transition and output logic
  always @(*) begin
    case (state)
      S0: begin
        if (x) begin
          next_state = S1;
        end else begin
          next_state = S0;
        end
        z = 0;
      end
      
      S1: begin
        if (x) begin
          next_state = S2;
        end else begin
          next_state = S1;
        end
        z = 0;
      end
      
      S2: begin
        if (x) begin
          next_state = S1;
          z = 1;
        end else begin
          next_state = S0;
          z = 0;
        end
      end
    endcase
  end

endmodule