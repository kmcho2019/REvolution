module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @ (posedge clk) begin
    state <= a | b;
end

always @ (*) begin
    if (a && b) begin
        q = state;
    end else if (a || b) begin
        q = 1;
    end else begin
        q = state;
    end
end

endmodule