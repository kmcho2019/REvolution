module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

always @(*) begin
    if (clock == 1'b1) begin
        p = a;
    end else begin
        p = 0;
    end
end

always @(posedge clock) begin
    if (a == 1'b1) begin
        q <= 1'b1;
    end
end

always @(negedge clock) begin
    if (a == 1'b1) begin
        q <= 1'b1;
        p <= 1'b1;
    end else if (p == 1'b0 && q == 1'b1) begin
        // No change
    end else begin
        p <= 0;
    end
end

initial begin
    q = 0;
    p = 0;
end

endmodule