module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if (!a) begin
        q <= 0;
    end
end

always @(negedge clock) begin
    if (p) begin
        q <= 1;
    end else if (!a) begin
        q <= 0;
    end
end

endmodule