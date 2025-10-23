module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
enum logic [0:0] {A, B} currentState, nextState;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= B;
    end else begin
        currentState <= nextState;
    end
end

// Next state logic
always_comb begin
    case (currentState)
        A: begin
            if (!in) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        B: begin
            if (!in) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        default: begin
            nextState = B; // default state
        end
    endcase
end

// Output logic
always_comb begin
    case (currentState)
        A: out = 1'b0;
        B: out = 1'b1;
        default: out = 1'b1; // default output
    endcase
end

endmodule