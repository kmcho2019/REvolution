module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

reg [0:0] state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 1; // Reset to state B
    end else begin
        case (state)
            1'b1: // State B
                if (in == 1'b1) begin
                    state <= 1'b1; // Stay in B
                end else begin
                    state <= 1'b0; // Go to A
                end
            1'b0: // State A
                if (in == 1'b1) begin
                    state <= 1'b0; // Stay in A
                end else begin
                    state <= 1'b1; // Go to B
                end
            default: state <= 1'b1; // Should never reach here, default to B
        endcase
    end
end

// Output logic
always @(*) begin
    case (state)
        1'b1: out = 1'b1; // State B
        1'b0: out = 1'b0; // State A
        default: out = 1'b1; // Should never reach here, default to B
    endcase
end

endmodule