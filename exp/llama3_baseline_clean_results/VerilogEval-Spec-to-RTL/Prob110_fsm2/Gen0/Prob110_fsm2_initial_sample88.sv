module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [1:0] state; // 0: OFF, 1: ON

always @(*) begin
    if (areset) begin
        state = 0; // Reset to OFF state
        out = 0;
    end
end

always @(posedge clk) begin
    if (areset) begin
        state = 0; // Synchronous reset
        out = 0;
    end else begin
        case (state)
            0: begin // OFF state
                if (j == 1'b1) begin
                    state = 1; // Transition to ON
                    out = 1'b1;
                end else begin
                    state = 0; // Stay in OFF
                    out = 1'b0;
                end
            end
            1: begin // ON state
                if (k == 1'b1) begin
                    state = 0; // Transition to OFF
                    out = 1'b0;
                end else begin
                    state = 1; // Stay in ON
                    out = 1'b1;
                end
            end
        endcase
    end
end

endmodule