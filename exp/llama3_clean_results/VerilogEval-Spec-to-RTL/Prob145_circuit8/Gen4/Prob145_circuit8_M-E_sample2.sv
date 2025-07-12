module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if (a) begin
        q <= a;
    end else if (p) begin
        q <= p;
    end
end

always @(negedge clock) begin
    if (a) begin
        q <= 0;
    end
end

endmodule