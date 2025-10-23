module TopModule (
  input clk,
  input aresetn,
  input x,
  output z
);

// Binary encoding for states
reg [1:0] state; // state register
localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10; // state encodings

always @ (posedge clk or negedge aresetn) begin
  if (!aresetn) begin // async reset
    state <= S0;
  end else begin
    case (state)
      S0: state <= x ? S1 : S0;
      S1: state <= ~x ? S2 : (x ? S1 : S0);
      S2: state <= x ? S1 : S0;
    endcase
  end
end

// Output z is asserted when the sequence "101" is detected
assign z = (state == S1 && x) || (state == S2 && ~x);

endmodule