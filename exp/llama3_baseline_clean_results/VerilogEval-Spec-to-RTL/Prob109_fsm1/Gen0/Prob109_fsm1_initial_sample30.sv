module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg [0:0] state; // 0 for A, 1 for B

always @(*) begin
    if(areset) begin
        state <= 1; // Reset to state B
    end else begin
        case(state)
            1'b1: begin // State B
                if(in == 1'b0) begin
                    state <= 1'b0; // Transition to A on in = 0
                end else begin
                    state <= 1'b1; // Stay in B on in = 1
                end
            end
            1'b0: begin // State A
                state <= 1'b1; // Transition to B regardless of in
            end
        endcase
    end
end

always @(*) begin
    case(state)
        1'b1: out <= 1'b1; // Output 1 when in state B
        1'b0: out <= 1'b0; // Output 0 when in state A
    endcase
end

endmodule