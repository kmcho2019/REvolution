module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    p <= a;
    if (a == 1'b1) begin
        q <= 1'b1;
    end else begin
        if (prev_a == 1'b1) begin
            q <= 1'b1;
        end
    end
end

always @(negedge clock) begin
    if (a == 1'b1) begin
        q <= 1'b0;
        p <= 1'b0;
    end
end

always @(posedge clock) begin
    prev_a <= a;
end

initial begin
    p = 1'bx;
    q = 1'bx;
end

endmodule