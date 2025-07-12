module TopModule (
  input clk,
  input aresetn,
  input x,
  output z
);

reg [1:0] state; // Reduced state register
localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10; // State encodings

always @ (posedge clk or negedge aresetn) begin
  if (!aresetn) begin // Async reset
    state <= S0;
  end else begin
    case (state)
      S0: begin
        if (x) begin
          state <= S1;
        end
      end
      S1: begin
        if (!x) begin
          state <= S2;
        end else begin
          state <= S1;
        end
      end
      S2: begin
        if (x) begin
          state <= S1; // Recognized "101"
        end else begin
          state <= S0;
        end
      end
    endcase
  end
end

// Output z is asserted when in S2 and x is '1'
assign z = (state == S2) && x;

endmodule