module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if (a && p) begin
        q <= 1;
    end else if (!clock) begin
        q <= 0;
    end
end

always @(negedge clock) begin
    if (!a) begin
        q <= 0;
    end
    p <= 0;
end

initial begin
    p = 0;
    q = 0;
end

endmodule