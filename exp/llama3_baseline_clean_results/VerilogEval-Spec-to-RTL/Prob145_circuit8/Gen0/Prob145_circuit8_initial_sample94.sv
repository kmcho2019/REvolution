module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (!a) begin
        p <= 0;
        q <= (q == 1'b1) ? q : 0;
    end else begin
        p <= 1;
        q <= (q == 1'b0 && p == 1'b1) ? 1'b1 : (q == 1'b1) ? q : 0;
    end
end

always @(negedge clock) begin
    if (a) begin
        q <= 1;
    end else begin
        p <= (p == 1'b1) ? p : 0;
        q <= (q == 1'b1) ? q : 0;
    end
end

endmodule