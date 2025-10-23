module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if (a == 1) begin
        q <= 1;
    end
end

always @(negedge clock) begin
    if (a == 0 && p == 0) begin
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule