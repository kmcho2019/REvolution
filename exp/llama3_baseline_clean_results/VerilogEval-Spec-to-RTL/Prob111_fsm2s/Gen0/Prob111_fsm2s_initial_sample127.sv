module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // Current state (0 - OFF, 1 - ON)

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to state OFF
        out <= 0;
    end else begin
        case (state)
            0: begin // State OFF
                if (j) begin
                    state <= 1; // Transition to state ON
                    out <= 1;
                end else begin
                    state <= 0; // Stay in state OFF
                    out <= 0;
                end
            end
            1: begin // State ON
                if (k) begin
                    state <= 0; // Transition to state OFF
                    out <= 0;
                end else begin
                    state <= 1; // Stay in state ON
                    out <= 1;
                end
            end
        endcase
    end
end

endmodule