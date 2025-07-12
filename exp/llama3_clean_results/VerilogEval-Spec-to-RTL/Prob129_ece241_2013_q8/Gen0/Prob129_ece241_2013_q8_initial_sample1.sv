module TopModule (
  input clk,
  input aresetn,
  input x,
  output z
);

reg [1:0] state; // state register
localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10; // state encodings

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