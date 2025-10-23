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

always @(*) begin
    if (!a && b) begin
        q = 1'b1; // q is high when a is low and b is high
    end else if (a && !b) begin
        q = 1'b1; // q is high when a is high and b is low
    end else begin
        q = 1'b0; // Otherwise, q is low
    end
end

endmodule