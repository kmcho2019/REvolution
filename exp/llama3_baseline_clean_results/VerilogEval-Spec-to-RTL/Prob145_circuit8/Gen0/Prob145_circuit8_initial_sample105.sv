module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    if (a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

always @(negedge clock) begin
    if (p) begin
        q <= 1'b1;
    end else if (prev_p) begin
        q <= 1'b1;
    end else begin
        q <= 1'b0;
    end
    prev_p <= p;
end

initial begin
    p = 1'b0;
    q = 1'b0;
    prev_p = 1'b0;
end

endmodule