module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [1:0] state; // 0: OFF, 1: ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // Transition to ON state if j is high
                end else begin
                    state <= 0; // Stay in OFF state if j is low
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // Transition to OFF state if k is high
                end else begin
                    state <= 1; // Stay in ON state if k is low
                end
            end
        endcase
    end
end

assign out = state; // Output is 1 in ON state and 0 in OFF state

endmodule