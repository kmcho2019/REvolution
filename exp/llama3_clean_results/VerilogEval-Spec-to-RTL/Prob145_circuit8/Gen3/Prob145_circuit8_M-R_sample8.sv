module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (!clock) begin
        if (a == 1'b1) begin
            p <= 1'b0;
            q <= 1'b0;
        end else begin
            p <= p;
            q <= q;
        end
    end else begin
        if (a == 1'b1) begin
            p <= 1'b1;
            if (p == 1'b1) begin
                q <= 1'b1;
            end
        end else begin
            p <= 1'b0;
            q <= q;
        end
    end
end

endmodule