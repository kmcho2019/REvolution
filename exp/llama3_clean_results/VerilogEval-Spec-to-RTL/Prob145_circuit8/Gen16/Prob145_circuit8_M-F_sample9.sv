module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
end

always @(posedge clock or negedge clock) begin
    if (~clock && a) begin
        q <= 1'b0;
    end else if (clock && a) begin
        q <= 1'b1;
    end else if (clock && ~a && p) begin
        q <= 1'b1;
    end else begin
        q <= q;
    end
end

endmodule