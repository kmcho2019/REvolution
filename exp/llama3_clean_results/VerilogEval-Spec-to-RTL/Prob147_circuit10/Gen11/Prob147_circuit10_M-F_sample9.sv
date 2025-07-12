module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (!a) begin
        state <= b;
    end else begin
        state <= state;
    end
end

always @(posedge clk) begin
    if (a) begin
        q <= ~b;
    end else begin
        q <= state;
    end
end

initial begin
    state = 0;
end

endmodule