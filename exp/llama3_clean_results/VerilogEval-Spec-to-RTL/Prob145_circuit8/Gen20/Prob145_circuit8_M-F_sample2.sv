module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;
reg prev_a;

always @(posedge clock) begin
    p <= a;
end

always @(negedge clock) begin
    if (prev_a) begin
        q <= 1'b1;
    end else if (prev_p) begin
        q <= 1'b1;
    end else begin
        q <= 1'b0;
    end
    prev_p <= p;
    prev_a <= a;
end

always @(posedge clock) begin
    prev_a <= a;
end

endmodule