module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    prev_a <= a;
    // p updates only when a changes from previous cycle
    if (a != prev_a) begin
        p <= a;
    end
end

always @(negedge clock) begin
    if (!a) begin
        q <= 1'b0;
    end else begin
        q <= p;
    end
end

initial begin
    p = 1'b0;
    q = 1'b0;
    prev_a = 1'b0;
end

endmodule