module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 0;
    q = 0;
end

always @(posedge clock) begin
    if (a) begin
        p = 1;
    end else begin
        p = 0;
    end
    q = p;
end

endmodule