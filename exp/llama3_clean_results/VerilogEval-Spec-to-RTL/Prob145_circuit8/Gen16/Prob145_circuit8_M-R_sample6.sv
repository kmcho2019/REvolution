module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state_p;

always @(posedge clock) begin
    p <= a;
    state_p <= a;
end

always @(posedge clock or negedge clock) begin
    if (clock == 1) begin
        if (a == 1) begin
            q <= 1;
        end else if (state_p == 1) begin
            q <= 0;
        end
    end else begin // clock == 0
        if (a == 0 && state_p == 0) begin
            q <= 0;
        end
    end
end

initial begin
    p = 0;
    q = 0;
    state_p = 0;
end

endmodule