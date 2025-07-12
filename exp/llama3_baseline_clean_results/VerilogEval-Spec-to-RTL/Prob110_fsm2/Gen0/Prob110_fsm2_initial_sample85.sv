module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg state; // 0 for OFF, 1 for ON
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case(state)
            0: // OFF state
                if(j) begin
                    state <= 1; // Transition to ON if j=1
                end else begin
                    state <= 0; // Stay in OFF if j=0
                end
            1: // ON state
                if(k) begin
                    state <= 0; // Transition to OFF if k=1
                end else begin
                    state <= 1; // Stay in ON if k=0
                end
            default: state <= 0; // Should not reach here, but for synthesis
        endcase
    end
end

// Continuous assignment for output 'out' based on the state
assign out = state;

endmodule