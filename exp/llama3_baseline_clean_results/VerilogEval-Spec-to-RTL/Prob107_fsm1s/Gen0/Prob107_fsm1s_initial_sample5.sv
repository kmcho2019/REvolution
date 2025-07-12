module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
    end else begin
        case(state)
            0: begin // State B
                if (~in) begin
                    state <= 1; // Move to state A
                end else begin
                    state <= 0; // Stay in state B
                end
            end
            1: begin // State A
                if (~in) begin
                    state <= 0; // Move to state B
                end else begin
                    state <= 1; // Stay in state A
                end
            end
        endcase
    end
end

always @ (*) begin
    case(state)
        0: out = 1; // In state B, out is 1
        1: out = 0; // In state A, out is 0
    endcase
end

endmodule