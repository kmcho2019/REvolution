module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(negedge clock) begin
    q <= a;
end

always @(posedge clock) begin
    if (a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

endmodule