module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// p updates on rising clock edges
always @(posedge clock) begin
    p <= a;
end

// q updates on falling clock edges with clear condition
always @(negedge clock) begin
    if (!a) begin
        p <= 1'b0;
        q <= 1'b0;
    end else begin
        q <= p;
    end
end

endmodule