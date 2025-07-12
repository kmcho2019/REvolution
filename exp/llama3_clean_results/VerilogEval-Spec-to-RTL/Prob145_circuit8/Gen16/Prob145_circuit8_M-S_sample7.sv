module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (clock) begin
        p <= a;
        if (a == 1) begin
            q <= 1;
        end else begin
            q <= q; // retain the previous value
        end
    end else begin
        if (a == 0 && p == 0) begin
            q <= 0;
        end else begin
            q <= q; // retain the previous value
        end
    end
end

endmodule