module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if (p) begin
        q <= 1'b1;
    end
end

always @(negedge clock) begin
    if (!a && q) begin
        q <= 1'b0;
    end
end

endmodule