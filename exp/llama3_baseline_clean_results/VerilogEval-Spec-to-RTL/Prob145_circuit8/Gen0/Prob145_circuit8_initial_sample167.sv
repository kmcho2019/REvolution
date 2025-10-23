module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a) begin
        p = ~p;
    end else begin
        p = 0;
    end
end

always @(negedge clock) begin
    if (a) begin
        q = 1;
    end else if (~a) begin
        q = 0;
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule