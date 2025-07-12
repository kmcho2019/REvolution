module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state; // 0: OFF, 1: ON
reg [0:0] nextState;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to OFF state
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        0: begin // OFF state
            if (j) begin
                nextState = 1; // Transition to ON state
                out = 0;
            end else begin
                nextState = 0; // Stay in OFF state
                out = 0;
            end
        end
        1: begin // ON state
            if (k) begin
                nextState = 0; // Transition to OFF state
                out = 1;
            end else begin
                nextState = 1; // Stay in ON state
                out = 1;
            end
        end
        default: begin
            nextState = 0;
            out = 0;
        end
    endcase
end

endmodule