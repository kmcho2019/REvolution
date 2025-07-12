module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state; // 0: idle, 1: set_p

always @(posedge clock) begin
    if (a) begin
        p <= 1;
        state <= 1;
    end else if (state) begin
        q <= 1;
        state <= 0;
    end else begin
        p <= 0;
    end
end

initial begin
    state <= 0;
    p <= 0;
    q <= 0;
end

endmodule