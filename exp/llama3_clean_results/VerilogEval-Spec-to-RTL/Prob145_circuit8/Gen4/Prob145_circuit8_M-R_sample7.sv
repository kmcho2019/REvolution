module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    p <= a;
    prev_p <= p;
end

always @(negedge clock) begin
    if (a) begin
        q <= 0;
    end else if (prev_p) begin
        q <= 1;
    end
end

endmodule