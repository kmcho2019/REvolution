module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (posedge clock) begin
        if (a) begin
            p <= 1;
        end else begin
            p <= 0;
        end
    end else if (negedge clock) begin
        if (a && p) begin
            q <= 1;
        end else if (~a && q) begin
            q <= 0;
        end
    end
end

endmodule