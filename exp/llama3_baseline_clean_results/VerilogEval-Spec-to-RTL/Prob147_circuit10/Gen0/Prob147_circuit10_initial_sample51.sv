module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    state <= a;
    if (b && !state) begin
        q <= 1'b1;
    end else if (!b && state) begin
        q <= 1'b1;
    end else begin
        q <= 1'b0;
    end
end

endmodule