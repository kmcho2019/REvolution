module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (~clock && a) begin
        p <= 0;
        q <= q;
    end else if (clock && a) begin
        p <= 1;
        q <= 0;
    end else if (~clock && ~a) begin
        p <= 0;
        q <= q;
    end else if (clock && ~a) begin
        p <= 0;
        if (~a) begin
            q <= 0;
        end else begin
            q <= q;
        end
    end
end

always @(posedge clock) begin
    if (a) begin
        p <= a;
    end
end

always @(negedge clock) begin
    if (p) begin
        q <= p;
    end
end

endmodule