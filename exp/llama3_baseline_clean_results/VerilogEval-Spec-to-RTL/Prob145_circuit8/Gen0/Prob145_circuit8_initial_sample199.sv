module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    prev_p <= p;
    if (a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

always @(negedge clock) begin
    if (prev_p) begin
        q <= 1'b1;
    end else if (a && clock) begin
        q <= 1'b1;
    end else begin
        q <= 1'b0;
    end
end

initial begin
    p = 1'b0;
    q = 1'b0;
    prev_p = 1'b0;
end

endmodule