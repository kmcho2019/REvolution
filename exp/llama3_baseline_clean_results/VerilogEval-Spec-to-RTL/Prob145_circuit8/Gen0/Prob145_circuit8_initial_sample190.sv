module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a) begin
        p <= 1'b1;
        q <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

always @(negedge clock) begin
    q <= 1'b0;
end

initial begin
    p = 1'bx;
    q = 1'bx;
end

endmodule