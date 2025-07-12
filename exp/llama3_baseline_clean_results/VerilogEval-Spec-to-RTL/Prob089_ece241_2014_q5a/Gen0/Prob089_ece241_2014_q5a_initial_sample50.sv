module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [1:0] state; // 2 states: 0 - initial/accumulation, 1 - inverting
reg [1:0] nextState;
reg invert; // Flag to indicate if we should invert the output

always @(*) begin
    case(state)
        0: begin // Initial state
            if (!areset) begin
                nextState = 0; // Stay in initial state until areset is deasserted
            end else begin
                nextState = 1; // Move to accumulation state when areset is asserted
            end
            invert = 1'b0;
        end
        1: begin // Accumulation state
            if (!areset) begin
                nextState = 0; // Reset state when areset is deasserted
            end else begin
                nextState = 1; // Stay in accumulation state
            end
            // No need to explicitly set invert here, as it's managed by the sequential logic below
        end
        default: nextState = 0;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset state
        invert <= 1'b0;
    end else begin
        state <= nextState;
        if (state == 1'b1 && x == 1'b1) begin // If input is 1, start inverting
            invert <= 1'b1;
        end
    end
end

always @(*) begin
    if (invert) begin
        z = ~x;
    end else begin
        z = x;
    end
end

endmodule