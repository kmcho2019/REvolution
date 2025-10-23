module TopModule (
    input  clock,
    input  a,
    output reg p,
    output reg q
);

reg prev_clock;
reg prev_a;

always @(*) begin
    p = a && clock;
    if (clock && !prev_clock) begin
        q <= a;
    end else begin
        q <= q;
    end
end

always @(posedge clock) begin
    prev_clock <= clock;
    prev_a <= a;
end

initial begin
    prev_clock = 0;
    prev_a = 0;
    p = 0;
    q = 0;
end

endmodule