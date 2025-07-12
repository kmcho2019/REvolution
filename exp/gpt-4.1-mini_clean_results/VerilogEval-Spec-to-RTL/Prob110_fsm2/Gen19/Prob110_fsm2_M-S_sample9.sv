module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg state;
localparam OFF = 1'b0, ON = 1'b1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
        out <= 1'b0;
    end else begin
        case (state)
            OFF: begin
                state <= j ? ON : OFF;
                out <= 1'b0;
            end
            ON: begin
                state <= k ? OFF : ON;
                out <= 1'b1;
            end
        endcase
    end
end

endmodule