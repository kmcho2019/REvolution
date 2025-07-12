module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

// Define states
parameter OFF = 0, ON = 1;
reg [0:0] currentState, nextState;

// Determine next state based on current state and inputs
always @(posedge clk) begin
    if (reset) begin
        currentState <= OFF;
    end else begin
        currentState <= nextState;
    end
end

// Determine next state and output based on current state and inputs
always @(*) begin
    case (currentState)
        OFF: begin
            if (j == 1'b1) begin
                nextState = ON;
            end else begin
                nextState = OFF;
            end
            out = 1'b0;
        end
        ON: begin
            if (k == 1'b1) begin
                nextState = OFF;
            end else begin
                nextState = ON;
            end
            out = 1'b1;
        end
    endcase
end

endmodule