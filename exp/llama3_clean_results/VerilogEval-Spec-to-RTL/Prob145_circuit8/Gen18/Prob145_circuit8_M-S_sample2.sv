module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock or a) begin
    if (clock) begin
        p = a;
        if (a) q = p;
    end else if (!a && q) begin
        q = 0;
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule