module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock or negedge clock) begin
    if (clock) begin
        p <= a;
        if (prev_p) begin
            q <= 1;
        end
    end else begin
        if (a) begin
            q <= 0;
        end
    end
    prev_p <= p;
end

endmodule