module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state; // 0: search, 1: complement

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
            z <= 0;
        end else if (~state) begin
            z <= x;
            state <= x;
        end else begin
            z <= ~x;
        end
    end

endmodule