module TopModule(
    input  d,
    input  ena,
    output reg q
);
    always @(ena or d) begin
        if (ena) begin
            q = d;
        end else begin
            q = q; // explicit latch hold to help synthesis
        end
    end
endmodule