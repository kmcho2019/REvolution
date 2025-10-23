module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state; // 0: A, 1: B

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Reset to state B
    end else begin
        case(state)
            0: begin // State A
                if (!in) begin
                    state <= 1; // Go to state B
                end else begin
                    state <= 0; // Stay in state A
                end
            end
            1: begin // State B
                if (!in) begin
                    state <= 0; // Go to state A
                end else begin
                    state <= 1; // Stay in state B
                end
            end
        endcase
    end
end

always @(state) begin
    case(state)
        0: out <= 0; // State A
        1: out <= 1; // State B
    endcase
end

initial begin
    state = 1; // Initialize state to B
    out = 1; // Initialize output to 1
end

endmodule