module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    prev_p <= p;
    p <= a;
    q <= prev_p;
end

always @(negedge clock) begin
    if (a) begin
        p <= 0;
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    prev_p = 0;
end

endmodule