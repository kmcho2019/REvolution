module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // 0 for OFF, 1 for ON

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // Transition to ON
                end else begin
                    state <= 0; // Stay in OFF
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // Transition to OFF
                end else begin
                    state <= 1; // Stay in ON
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: out <= 0; // OUT is 0 in OFF state
        1: out <= 1; // OUT is 1 in ON state
    endcase
end

endmodule