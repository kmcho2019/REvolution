module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if (a) begin
        q <= p;
    end else begin
        q <= q;
    end
end

always @(negedge clock) begin
    if (!a) begin
        if(!p) begin
            q <= 0;
        end
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule