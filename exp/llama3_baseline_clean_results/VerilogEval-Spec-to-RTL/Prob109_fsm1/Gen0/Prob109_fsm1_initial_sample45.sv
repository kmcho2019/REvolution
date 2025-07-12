module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state; // Current state: 0 for A, 1 for B
reg [0:0] nextState; // Next state

always @(*) begin
    case(state)
        0: begin // State A
            if (in == 0) begin
                nextState = 1; // Go to B on input 0
            end else begin
                nextState = 0; // Stay in A on input 1
            end
        end
        1: begin // State B
            if (in == 0) begin
                nextState = 0; // Go to A on input 0
            end else begin
                nextState = 1; // Stay in B on input 1
            end
        end
        default: begin
            nextState = 1; // Default to state B
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // Reset to state B
    end else begin
        state <= nextState;
    end
end

assign out = state; // Output directly determined by state

endmodule