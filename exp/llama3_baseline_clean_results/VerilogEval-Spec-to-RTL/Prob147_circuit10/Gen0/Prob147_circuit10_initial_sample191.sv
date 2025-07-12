module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a && b) begin
        state <= ~state;
    end else if (!a && !b) begin
        state <= state || !state;
    end else begin
        state <= state;
    end
end

always @(*) begin
    q <= state || b;
end

endmodule