module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define the states
enum logic [0:0] {OFF, ON} currentState, nextState;

// Update the state
always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= OFF;
    end else begin
        currentState <= nextState;
    end
end

// Determine the next state
always_comb begin
    case (currentState)
        OFF: begin
            if (j) begin
                nextState = ON;
            end else begin
                nextState = OFF;
            end
        end
        ON: begin
            if (k) begin
                nextState = OFF;
            end else begin
                nextState = ON;
            end
        end
        default: begin
            nextState = OFF;
        end
    endcase
end

// Assign the output
always_comb begin
    case (currentState)
        OFF: out = 0;
        ON: out = 1;
        default: out = 0;
    endcase
end

endmodule