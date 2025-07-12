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
    if (!clock && p) begin
        q <= 1;
    end else if (clock && a) begin
        q <= 1;
    end else if (!clock && !a) begin
        q <= 0;
    end
end

endmodule