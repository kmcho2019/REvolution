module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    prev_a <= a;
    if (a) begin
        p <= 1'b1;
        q <= 1'b0;
    end else begin
        p <= 1'b0;
        q <= 1'b0;
    end
end

always @(negedge clock) begin
    if (prev_a) begin
        q <= 1'b1;
    end else begin
        q <= 1'b0;
    end
    p <= (prev_a)? 1'b1 : 1'b0;
end

endmodule