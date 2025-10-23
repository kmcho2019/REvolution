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
        state <= state; // Hold the previous state when a is high
    end
end

always @(*) begin
    if (!a) begin
        q = b;
    end else begin
        q = ~b; // q is the inverse of b when a is high
    end
end

endmodule