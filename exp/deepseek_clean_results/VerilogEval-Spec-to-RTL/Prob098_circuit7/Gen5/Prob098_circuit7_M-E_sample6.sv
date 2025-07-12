module TopModule (
    input clk,
    input a,
    output reg q
);

reg state;

always @(posedge clk) begin
    if (!state) begin
        if (a) begin
            state <= 1'b1;
            q <= 1'b0;
        end else begin
            q <= 1'b1;
        end
    end
end

initial begin
    state = 1'b0;
    q = 1'bx;
end

endmodule