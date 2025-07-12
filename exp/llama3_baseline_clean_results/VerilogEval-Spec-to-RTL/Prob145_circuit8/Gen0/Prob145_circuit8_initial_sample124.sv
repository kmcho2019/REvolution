module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if(a) begin
        q <= 1;
    end
end

always @(*) begin
    if(!clock) begin
        q <= q;
        p <= 0;
    end
end

initial begin
    q = 0;
    p = 0;
end

endmodule