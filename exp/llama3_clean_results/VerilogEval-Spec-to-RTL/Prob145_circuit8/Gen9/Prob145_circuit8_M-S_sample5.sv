module TopModule(
    input clock,
    input a,
    output reg p = 0,
    output reg q = 0
);

always @(posedge clock or negedge clock) begin
    if (clock) begin
        p <= a;
    end else begin
        if (a) begin
            q <= 0;
        end else if (p) begin
            q <= 1;
        end
    end
end

endmodule