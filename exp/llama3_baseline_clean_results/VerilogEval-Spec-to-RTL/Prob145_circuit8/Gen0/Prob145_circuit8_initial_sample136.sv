module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a) begin
        p = ~p;
    end else begin
        p = 0;
    end
end

always @(posedge clock or negedge clock) begin
    if (~clock) begin
        q = p;
    end else begin
        if (a) begin
            q = p;
        end else begin
            q = q;
        end
    end
end

endmodule