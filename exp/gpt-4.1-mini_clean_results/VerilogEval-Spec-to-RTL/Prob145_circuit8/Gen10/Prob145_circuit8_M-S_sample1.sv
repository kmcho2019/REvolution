module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg initialized;

always @(posedge clock) begin
    if (!initialized) begin
        p <= 0;
        q <= 0;
        initialized <= 1;
    end else begin
        p <= a;
    end
end

always @(negedge clock) begin
    if (initialized) begin
        q <= p;
    end
end

initial begin
    initialized = 0;
    p = 1'bx;
    q = 1'bx;
end

endmodule