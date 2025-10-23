module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

reg state; // current state

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case (state)
            1'b0: // OFF state
                if (j) begin
                    state <= 1'b1; // Transition to ON state
                end else begin
                    state <= 1'b0; // Stay in OFF state
                end
            1'b1: // ON state
                if (k) begin
                    state <= 1'b0; // Transition to OFF state
                end else begin
                    state <= 1'b1; // Stay in ON state
                end
        endcase
    end
end

// Output logic
always @(*) begin
    case (state)
        1'b0: out = 1'b0; // Output 0 when in OFF state
        1'b1: out = 1'b1; // Output 1 when in ON state
    endcase
end

endmodule