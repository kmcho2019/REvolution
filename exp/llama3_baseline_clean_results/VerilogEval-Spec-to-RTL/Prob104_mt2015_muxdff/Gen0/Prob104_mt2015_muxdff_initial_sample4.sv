module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q);

    reg q_reg;

    always @(posedge clk) begin
      if (L) begin
        q_reg <= q_in;
      end else begin
        q_reg <= r_in;
      end
    end

    assign Q = q_reg;

endmodule