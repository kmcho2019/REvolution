module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

reg prev_a;
reg prev_clock;

always @ (posedge clock or negedge clock) begin
    prev_a <= a;
    prev_clock <= clock;
end

always @ (posedge clock) begin
    if (a) begin
        p <= 1;
    end else begin
        p <= 0;
    end
end

always @ (posedge clock) begin
    if (prev_clock == 0 && a) begin
        q <= 1;
    end else if (clock == 1 && a) begin
        q <= 1;
    end else if (prev_clock == 0 && prev_a == 1 && a == 0) begin
        q <= 0;
    end else if (clock == 0 && a == 1 && prev_clock == 1) begin
        q <= 1;
    end else begin
        q <= q;
    end
end

endmodule