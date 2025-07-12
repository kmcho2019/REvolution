module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [1:0] state; // State variable (OFF = 0, ON = 1)

// Asynchronous reset to state OFF
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // State OFF
                if (j) begin
                    state <= 1; // Transition to ON state if j = 1
                end else begin
                    state <= 0; // Stay in OFF state if j = 0
                end
            end
            1: begin // State ON
                if (k) begin
                    state <= 0; // Transition to OFF state if k = 1
                end else begin
                    state <= 1; // Stay in ON state if k = 0
                end
            end
            default: state <= 0; // Default state is OFF
        endcase
    end
end

// Output 'out' is determined by the current state
always @(*) begin
    case (state)
        0: out = 0; // Output is 0 in state OFF
        1: out = 1; // Output is 1 in state ON
        default: out = 0; // Default output is 0
    endcase
end

endmodule