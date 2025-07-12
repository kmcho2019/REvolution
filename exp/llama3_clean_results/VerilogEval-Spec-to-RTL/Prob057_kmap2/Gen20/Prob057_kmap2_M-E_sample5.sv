module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(a, b, c, d) begin
    if (~a && ~b) begin // a = 0, b = 0
        out = ~(c && d); // out = 1 for all except c = 1, d = 1
    end else if (~a && b) begin // a = 0, b = 1
        out = (~c && ~d) || (~c && d); // out = 1 for cd = 00 or cd = 10
    end else if (a && ~b) begin // a = 1, b = 0
        out = (~c && ~d); // Direct implementation for this case
    end else begin // a = 1, b = 1
        out = (~c && d) || (c && ~d) || (c && d); // out = 1 for cd = 01, cd = 11, cd = 10
    end
end

endmodule