module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // 1-bit variable to hold the state (A=0, B=1)

always @(*) begin
    case(state)
        1'b0: out = 1'b0; // State A, out = 0
        1'b1: out = 1'b1; // State B, out = 1
        default: out = 1'bx; // Invalid state, should not occur
    endcase
end

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        case(state)
            1'b0: begin
                if(in == 1'b0) begin
                    state <= 1'b1; // From A, in=0 -> B
                end else begin
                    state <= 1'b0; // From A, in=1 -> A
                end
            end
            1'b1: begin
                if(in == 1'b0) begin
                    state <= 1'b0; // From B, in=0 -> A
                end else begin
                    state <= 1'b1; // From B, in=1 -> B
                end
            end
            default: state <= 1'bx; // Should not occur
        endcase
    end
end

endmodule