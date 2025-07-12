module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // COPY state
            z <= 1'b0;
        end else begin
            state <= (state == 1'b0 && x == 1'b1) ? 1'b1 : state;
            z <= (state == 1'b0) ? x : ~x;
        end
    end

endmodule