module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (!clock) begin
        if (p) begin
            q <= 1;
        end
        else begin
            q <= 0;
        end
    end
    else begin
        if (a) begin
            p <= 1;
        end
        else begin
            p <= 0;
        end
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule