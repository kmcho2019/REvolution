module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// State definition
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
reg [1:0] state, next_state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= S0;
    start_shifting <= 0;
  end
  else begin
    state <= next_state;

    case (state)
      S0: begin // Initial State
        if (data) next_state = S1; 
        else next_state = S0;
      end
      S1: begin
        if (data) next_state = S2;
        else next_state = S0;
      end
      S2: begin
        if (data) next_state = S3;
        else next_state = S0;
      end
      S3: begin
        next_state = S0;
        start_shifting <= 1; // Signal sequence found
      end
    endcase
  end
end

endmodule