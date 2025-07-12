module TopModule (
  input clk,
  input aresetn,
  input x,
  output z
);

reg [2:0] state; // one-hot encoded state register
localparam S0 = 3'b001, S1 = 3'b010, S2 = 3'b100; // one-hot state encodings

always @ (posedge clk or negedge aresetn) begin
  if (!aresetn) begin // async reset
    state <= S0;
  end else begin
    case (state)
      S0: begin
        if (x) begin
          state <= S1;
        end else begin
          state <= S0;
        end
      end
      S1: begin
        if (x) begin
          state <= S1;
        end else begin
          state <= S2;
        end
      end
      S2: begin
        if (x) begin
          state <= S1; // recognized "101"
        end else begin
          state <= S0;
        end
      end
    endcase
  end
end

assign z = (state == S2) && x; // z asserted in S2 when x is '1'

endmodule