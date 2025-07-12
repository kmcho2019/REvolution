module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_was_high;

always @(posedge clock) begin
    p = a;
    if (a == 1'b1) begin
        a_was_high = 1'b1;
    end
end

always @(negedge clock) begin
    if (a == 1'b1) begin
        a_was_high = 1'b0;
        q = 1'b0;
    end else if (a_was_high == 1'b1) begin
        q = 1'b1;
    end
end

endmodule