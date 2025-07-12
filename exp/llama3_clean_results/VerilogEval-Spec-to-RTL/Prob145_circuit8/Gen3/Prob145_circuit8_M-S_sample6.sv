module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if (a == 1'b1) begin
        q <= 1'b1;
    end else if (q == 1'b1 && a == 1'b0) begin
        q <= 1'b0;
    end
end

always @(negedge clock) begin
    if (a == 1'b1) begin
        p <= 1'b0;
    end
    if (a == 1'b1) begin
        q <= 1'b0;
    end
end

endmodule