module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    if (a) begin
        p <= 1;
    end else begin
        p <= 0;
    end
end

always @(posedge clock) begin
    prev_a <= a;
end

always @(*) begin
    if (clock) begin
        if (a) begin
            q <= 1;
        end else if (prev_a) begin
            q <= 1;
        end else begin
            q <= 0;
        end
    end else begin
        if (prev_a) begin
            q <= 1;
        end else begin
            q <= 0;
        end
    end
end

initial begin
    prev_a = 0;
    p = 0;
    q = 0;
end

endmodule