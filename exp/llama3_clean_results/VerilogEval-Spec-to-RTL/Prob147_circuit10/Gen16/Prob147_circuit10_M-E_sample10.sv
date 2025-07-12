module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

always @(posedge clk) begin
    if (!a && !b) begin
        state <= 1;
    end else if (a && b) begin
        state <= 0;
    end
end

assign q = (state) ? 1 : b;

initial begin
    state = 1'b0;
end

endmodule