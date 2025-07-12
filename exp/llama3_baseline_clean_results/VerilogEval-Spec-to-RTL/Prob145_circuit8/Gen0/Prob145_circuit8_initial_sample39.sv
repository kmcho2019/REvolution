module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a) begin
        p <= ~p;
        q <= ~q;
    end
end

always @(negedge clock) begin
    if (a) begin
        #5; // wait for 5 time units to ensure a is still high after clock goes low
        if (~a) begin
            p <= 0;
            q <= 0;
        end
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule