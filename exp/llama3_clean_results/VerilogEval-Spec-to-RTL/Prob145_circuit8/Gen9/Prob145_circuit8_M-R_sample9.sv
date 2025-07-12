module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    p <= a;
    if (a) begin
        q <= 1;
    end else if (p == 0 && prev_p == 1) begin
        q <= 0;
    end
    prev_p <= p;
end

endmodule