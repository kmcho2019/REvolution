module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    if (a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

always @(negedge clock) begin
    if (a) begin
        q <= 1'b1;
    end else if (prev_a) begin
        q <= 1'b1;
    end else begin
        q <= 1'b0;
    end
    prev_a <= a;
end

endmodule