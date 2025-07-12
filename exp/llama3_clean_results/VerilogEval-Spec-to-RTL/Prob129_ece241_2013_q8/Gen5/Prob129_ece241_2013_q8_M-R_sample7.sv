module TopModule (
  input clk,
  input aresetn,
  input x,
  output z
);

reg [1:0] state; // State register
reg [1:0] next_state; // Next state register
localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10; // State encodings

// Next state logic using assign
assign next_state = (state == S0 && x)? S1 :
                    (state == S1 &&!x)? S2 :
                    (state == S2 && x)? S1 :
                    (state == S2 &&!x)? S0 :
                    (state == S1 && x)? S1 : S0;

// State register update
always @ (posedge clk or negedge aresetn) begin
  if (!aresetn) begin // Async reset
    state <= S0;
  end else begin
    state <= next_state;
  end
end

// Output z is asserted when in S2 and x is '1'
assign z = (state == S2) && x;

endmodule