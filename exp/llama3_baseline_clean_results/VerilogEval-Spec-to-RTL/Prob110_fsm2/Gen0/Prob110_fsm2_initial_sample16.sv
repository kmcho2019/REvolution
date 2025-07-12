module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // 0 for OFF, 1 for ON
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // Transition to ON if j=1
                end else begin
                    state <= 0; // Stay in OFF if j=0
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // Transition to OFF if k=1
                end else begin
                    state <= 1; // Stay in ON if k=0
                end
            end
            default: state <= 0; // Default to OFF if state is invalid
        endcase
    end
end

assign out = state; // out is 1 when state is ON, 0 when state is OFF

endmodule