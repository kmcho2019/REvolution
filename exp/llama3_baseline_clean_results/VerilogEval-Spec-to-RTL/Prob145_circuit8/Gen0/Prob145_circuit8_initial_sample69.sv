module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= (a == 1) ? 1 : 0;
end

always @(negedge clock) begin
    if (p == 1) begin
        q <= 1;
    end else begin
        q <= 0;
    end
end

endmodule