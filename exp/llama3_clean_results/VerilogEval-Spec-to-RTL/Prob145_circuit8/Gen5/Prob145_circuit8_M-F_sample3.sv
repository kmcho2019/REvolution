module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
end

always @(posedge clock or negedge clock) begin
    if (!clock && a) begin
        q <= 0;
    end else if (p) begin
        q <= 1;
    end
end

endmodule