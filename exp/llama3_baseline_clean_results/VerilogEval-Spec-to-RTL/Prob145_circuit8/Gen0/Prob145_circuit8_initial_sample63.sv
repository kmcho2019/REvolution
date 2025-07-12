module TopModule (
    input  clock,
    input  a,
    output p,
    output reg q
);

always @(posedge clock) begin
    if (a) begin
        p = 1'b1;
    end else begin
        p = 1'b0;
    end
end

always @(negedge clock) begin
    if (p) begin
        q = 1'b1;
    end else if (~a) begin
        q = 1'b0;
    end
end

endmodule