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
    end
end

always @(negedge clock) begin
    if (a == 1'b1) begin
        q <= 1'b0;
    end
end

endmodule