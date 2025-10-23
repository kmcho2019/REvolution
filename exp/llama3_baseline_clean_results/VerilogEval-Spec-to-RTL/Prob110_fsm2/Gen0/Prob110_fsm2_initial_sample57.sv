module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
enum logic [1:0] {OFF, ON} currentState, nextState;

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        currentState <= OFF;
    end else begin
        currentState <= nextState;
    end
end

// Next state logic
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

// Output logic
always_comb begin
    case (currentState)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule