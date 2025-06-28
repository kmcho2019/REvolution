module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [1:0] state;

parameter COUNTING = 2'b00;
parameter RESET = 2'b01;

always @ (posedge clk) begin
  case (state)
    COUNTING: begin
      if (a) begin
        if (q < 3'd6)
          q <= q + 1;
        state <= COUNTING;
      end else begin
        state <= RESET;
      end
    end
    RESET: begin
      if (a)
        state <= COUNTING;
      else
        q <= 3'b0;
    end
    default: state <= COUNTING;
  endcase
end

endmodule