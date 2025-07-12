module TopModule(
    input clock,
    input a,
    output reg p = 1'b0,
    output reg q = 1'b0
);

always @(posedge clock) begin
    p <= a;
end

always @(negedge clock) begin
    if (a) begin
        q <= 1'b0;
    end else if (p) begin
        q <= 1'b1;
    end
end

endmodule