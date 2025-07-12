module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define the states
enum logic [0:0] {OFF, ON} state, nextState;

// Synchronous reset and state update
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= nextState;
    end
end

// State transitions
always_comb begin
    case (state)
        OFF: begin
            if (j == 1) begin
                nextState = ON;
            end else begin
                nextState = OFF;
            end
        end
        ON: begin
            if (k == 1) begin
                nextState = OFF;
            end else begin
                nextState = ON;
            end
        end
        default: nextState = OFF;
    endcase
end

// Output logic
assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule