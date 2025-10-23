module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg state; // 0: OFF, 1: ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // Move to ON state if j=1
                end else begin
                    state <= 0; // Stay in OFF state if j=0
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // Move to OFF state if k=1
                end else begin
                    state <= 1; // Stay in ON state if k=0
                end
            end
        endcase
    end
end

always @(state) begin
    case (state)
        0: out = 0; // Output 0 in OFF state
        1: out = 1; // Output 1 in ON state
    endcase
end

endmodule