module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state; // 1-bit signal to represent the current state
parameter OFF = 1'b0;
parameter ON = 1'b1;

always @(posedge clk) begin
    if (reset) begin
        state <= OFF; // Reset to OFF state
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON; // Transition from OFF to ON when j is 1
                end else begin
                    state <= OFF; // Stay in OFF state when j is 0
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF; // Transition from ON to OFF when k is 1
                end else begin
                    state <= ON; // Stay in ON state when k is 0
                end
            end
            default: state <= OFF; // Default state
        endcase
    end
end

always @(*) begin
    case (state)
        OFF: out = 1'b0; // Output 0 when in OFF state
        ON: out = 1'b1; // Output 1 when in ON state
        default: out = 1'b0; // Default output
    endcase
end

endmodule