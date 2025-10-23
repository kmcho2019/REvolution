module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a == 1) begin
        p <= 1;
    end else begin
        p <= 0;
    end
end

always @(posedge clock or negedge clock) begin
    if (~clock && p) begin
        q <= 1;
    end else if (clock && a) begin
        q <= 1;
    end else if (~clock && ~a) begin
        q <= 0;
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule