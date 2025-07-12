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
    end
end

always @(negedge clock) begin
    // No operation, q remains the same
end

endmodule