module TopModule (
  input clk,
  input aresetn,
  input x,
  output z
);

// Binary encoding for states
reg [1:0] state; // state register
localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10; // state encodings

// Next state logic using assign statements
reg [1:0] next_state;
assign next_state = (state == S0 && x) ? S1 :
                     (state == S1 && ~x) ? S2 :
                     (state == S2 && x) ? S1 : S0;

// State register with asynchronous reset
always @ (posedge clk or negedge aresetn) begin
  if (!aresetn) begin // async reset
    state <= S0;
  end else begin
    state <= next_state;
  end
end

// Output z is asserted when state is S2 and x is '1'
assign z = (state == S2) && x;

endmodule