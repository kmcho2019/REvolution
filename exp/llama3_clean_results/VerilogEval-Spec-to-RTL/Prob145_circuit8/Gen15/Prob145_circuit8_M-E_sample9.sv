module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    if (a) begin
        p <= 1;
    end else begin
        p <= 0;
    end
    prev_p <= p;
end

always @(negedge clock) begin
    if (prev_p) begin
        q <= 1;
    end else begin
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
    prev_p = 0;
end

endmodule