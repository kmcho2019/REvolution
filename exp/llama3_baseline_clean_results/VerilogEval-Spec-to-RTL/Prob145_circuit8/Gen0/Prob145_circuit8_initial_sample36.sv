module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if (a) begin
        q <= 1'b1;
    end
end

always @(negedge clock) begin
    if (!a) begin
        q <= p;
    end
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule