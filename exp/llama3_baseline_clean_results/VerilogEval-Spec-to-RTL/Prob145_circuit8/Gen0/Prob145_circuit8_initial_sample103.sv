module TopModule(
    input  wire clock,
    input  wire a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a) begin
        p <= 1'b1;
        q <= 1'b0;
    end else begin
        p <= 1'b0;
        q <= 1'b0;
    end
end

always @(negedge clock) begin
    if (p) begin
        p <= 1'b0;
        q <= 1'b1;
    end
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule