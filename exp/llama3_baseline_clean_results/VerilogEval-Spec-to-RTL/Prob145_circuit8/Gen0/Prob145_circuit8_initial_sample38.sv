module TopModule(
    input  clock,
    input  a,
    output p,
    output reg q
);

reg prev_a;

always @(*) begin
    p = a & clock;
end

always @(posedge clock) begin
    prev_a <= a;
end

always @(negedge clock) begin
    q <= prev_a;
end

always @(posedge clock) begin
    if (a) begin
        q <= 1;
    end else if (prev_a) begin
        q <= 1;
    end else begin
        q <= 0;
    end
end

endmodule