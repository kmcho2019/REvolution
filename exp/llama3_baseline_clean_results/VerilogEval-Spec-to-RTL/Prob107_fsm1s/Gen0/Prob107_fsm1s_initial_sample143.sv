module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // Current state (0: B, 1: A)
reg [0:0] nextState; // Next state

// Define state transitions
always @(*) begin
    case(state)
        0: begin // State B
            if(in == 0) begin
                nextState = 1; // Go to state A
            end else begin
                nextState = 0; // Stay in state B
            end
        end
        1: begin // State A
            if(in == 0) begin
                nextState = 0; // Go to state B
            end else begin
                nextState = 1; // Stay in state A
            end
        end
    endcase
end

// Define state update on clock edge
always @(posedge clk) begin
    if(reset) begin // Reset to state B
        state <= 0;
    end else begin
        state <= nextState;
    end
end

// Define output based on current state
always @(*) begin
    case(state)
        0: out = 1; // State B: out = 1
        1: out = 0; // State A: out = 0
    endcase
end

endmodule