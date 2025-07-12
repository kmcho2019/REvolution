module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // 0: waiting for first 1, 1: seen first 1, 2: reset

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 2;
        z <= 0;
    end else if (state == 2) begin
        if (~areset) begin
            state <= 0;
        end
    end else if (state == 0) begin
        if (x) begin
            state <= 1;
            z <= 1;
        end else begin
            z <= 0;
        end
    end else if (state == 1) begin
        z <= ~x;
    end
end

endmodule