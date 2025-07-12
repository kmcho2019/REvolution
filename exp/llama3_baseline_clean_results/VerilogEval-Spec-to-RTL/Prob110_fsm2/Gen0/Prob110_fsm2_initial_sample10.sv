module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [1:0] state; // 0: OFF, 1: ON
parameter OFF = 0, ON = 1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
        out <= 0;
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                    out <= 1;
                end else begin
                    state <= OFF;
                    out <= 0;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                    out <= 0;
                end else begin
                    state <= ON;
                    out <= 1;
                end
            end
            default: state <= OFF;
        endcase
    end
end

endmodule