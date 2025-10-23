module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (a && b) begin
        state <= 0;
    end else if (!a && b) begin
        state <= 1;
    end
end

always @(*) begin
    if (!a || b) begin
        if (state) begin
            q = 1;
        end else begin
            q = 0;
        end
    end else begin
        q = 0;
    end
end

endmodule