module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 0;
    q = 0;
end

always @(posedge clock) begin
    p <= a;
end

always @(negedge clock) begin
    if (a) begin
        q <= 0;
    end else if (p) begin
        q <= 1;
    end
end

endmodule