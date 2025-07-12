module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // 0: OFF, 1: ON
reg [0:0] next_state;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // Transition to ON state
                end else begin
                    state <= 0; // Stay in OFF state
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // Transition to OFF state
                end else begin
                    state <= 1; // Stay in ON state
                end
            end
        endcase
    end
end

assign out = state; // out is 1 when state is ON, 0 when state is OFF

endmodule