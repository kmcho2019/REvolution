module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
    if (a) begin
        q <= 1'b1;
    end else if (!a && !p) begin
        q <= 1'b0;
    end
end

endmodule