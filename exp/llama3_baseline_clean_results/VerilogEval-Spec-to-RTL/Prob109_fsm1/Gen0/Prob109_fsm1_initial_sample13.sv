module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg [0:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        case (state)
            1'b0: begin // State A
                if (in == 1'b0) begin
                    state <= 1'b1; // Transition to state B
                end else begin
                    state <= 1'b0; // Stay in state A
                end
            end
            1'b1: begin // State B
                if (in == 1'b0) begin
                    state <= 1'b0; // Transition to state A
                end else begin
                    state <= 1'b1; // Stay in state B
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        1'b0: out = 1'b0; // Output in state A
        1'b1: out = 1'b1; // Output in state B
    endcase
end

endmodule