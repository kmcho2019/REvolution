module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // State register
reg [0:0] next_state; // Next state register

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        case (state)
            1'b1: // State B
                if (~in) begin
                    state <= 1'b0; // Move to state A
                end else begin
                    state <= 1'b1; // Stay in state B
                end
            1'b0: // State A
                if (~in) begin
                    state <= 1'b1; // Move to state B
                end else begin
                    state <= 1'b0; // Stay in state A
                end
            default:
                state <= 1'b1; // Default to state B
        endcase
    end
end

assign out = state; // Output is the state value

endmodule