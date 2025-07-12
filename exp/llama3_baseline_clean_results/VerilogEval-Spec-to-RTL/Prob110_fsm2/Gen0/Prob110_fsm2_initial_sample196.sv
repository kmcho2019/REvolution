module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

reg [0:0] state; // Using 1 bit to represent two states

always @(*) begin
    if (areset) begin // Asynchronous reset
        state = 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // State OFF
                if (j == 1) begin
                    state = 1; // Transition to ON
                end else begin
                    state = 0; // Stay in OFF
                end
            end
            1: begin // State ON
                if (k == 1) begin
                    state = 0; // Transition to OFF
                end else begin
                    state = 1; // Stay in ON
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    out = state; // Out is 1 when in state ON, 0 when in state OFF
end

endmodule