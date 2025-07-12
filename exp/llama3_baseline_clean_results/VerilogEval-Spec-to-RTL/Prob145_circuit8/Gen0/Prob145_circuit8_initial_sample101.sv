module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;
reg prev_clock;

initial begin
    p = 0;
    q = 0;
    prev_a = 0;
    prev_clock = 0;
end

always @(posedge clock) begin
    if (a) begin
        p <= 1;
    end else begin
        p <= 0;
    end
end

always @(negedge clock) begin
    if (prev_clock &&!prev_a) begin
        q <= 0;
    end else if (!prev_clock && prev_a) begin
        q <= 1;
    end
end

always @(posedge clock or negedge clock) begin
    prev_a <= a;
    prev_clock <= clock;
end

endmodule