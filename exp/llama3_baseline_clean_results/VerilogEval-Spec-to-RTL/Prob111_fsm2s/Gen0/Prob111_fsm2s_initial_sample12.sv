module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;  // 0 - OFF, 1 - ON

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;  // Reset to OFF state
    end else begin
        case (state)
            0: begin
                if (j) begin
                    state <= 1;  // Transition to ON state
                end else begin
                    state <= 0;  // Stay in OFF state
                end
            end
            1: begin
                if (k) begin
                    state <= 0;  // Transition to OFF state
                end else begin
                    state <= 1;  // Stay in ON state
                end
            end
        endcase
    end
end

always @ (*) begin
    out = state;  // Output is directly dependent on the state
end

endmodule