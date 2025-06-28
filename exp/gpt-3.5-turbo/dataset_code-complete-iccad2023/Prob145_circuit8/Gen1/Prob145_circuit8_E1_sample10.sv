module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg prev_p;

always @(posedge clock) begin
    if (a) begin
        p <= 1;
    end else begin
        p <= 0;
        q <= (prev_p == 0) ? 1 : 0;
    end
    prev_p <= p;
end

always @* begin
    q = (p == 1) ? ~a : q;
end

endmodule