module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state;

always @(posedge clk) begin
    if (b == 1'b1) begin
        if (a == 1'b1 && b == 1'b1) begin
            state <= ~state;
        end else begin
            state <= a;
        end
    end
end

assign q = b ? a : state;

endmodule