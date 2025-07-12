module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_clock;
reg a_high;

always @(posedge clock) begin
    p <= a;
    a_high <= a;
end

always @(negedge clock) begin
    q <= a_high;
end

always @(posedge clock) begin
    prev_clock <= clock;
end

always @(negedge clock) begin
    if (prev_clock) begin
        q <= a_high;
    end
end

initial begin
    p = 0;
    q = 0;
    prev_clock = 0;
    a_high = 0;
end

endmodule