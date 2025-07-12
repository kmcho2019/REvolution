module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 1'bx;
    q = 1'bx;
end

always @(posedge clock) begin
    if (p === 1'bx && q === 1'bx) begin
        // Initialize unknown states to 0 at first clock edge
        p <= 1'b0;
        q <= 1'b0;
    end else begin
        q <= p;
        if (q == 1'b0)
            p <= a;
        else
            p <= p; // hold previous value when q != 0
    end
end

endmodule