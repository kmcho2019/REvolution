module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

// Define states
enum logic [0:0] {OFF, ON} currentState, nextState;

always @(*) begin
    case(currentState)
        OFF: if (j) nextState = ON;
             else nextState = OFF;
        ON:  if (k) nextState = OFF;
             else nextState = ON;
        default: nextState = OFF; // This should never happen, but included for completeness
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        currentState <= OFF;
        out <= 0;
    end else begin
        currentState <= nextState;
        case(currentState)
            OFF: out <= 0;
            ON:  out <= 1;
            default: out <= 0; // Again, for completeness, though this shouldn't occur
        endcase
    end
end

initial begin
    currentState = OFF;
    out = 0;
end

endmodule