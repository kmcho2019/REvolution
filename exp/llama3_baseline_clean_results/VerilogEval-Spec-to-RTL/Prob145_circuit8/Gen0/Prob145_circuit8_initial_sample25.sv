module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg state;

initial begin
    state = 0;
    p = 0;
    q = 0;
end

always @(posedge clock) begin
    if (a) begin
        state = 1;
        p = 1;
        q = 0;
    end else if (state == 1) begin
        p = 0;
        q = 0;
    end
end

always @(negedge clock) begin
    if (state == 1) begin
        q = 1;
    end
end

always @(*) begin
    if (state == 1 && q == 1) begin
        p = 1;
    end
end

endmodule