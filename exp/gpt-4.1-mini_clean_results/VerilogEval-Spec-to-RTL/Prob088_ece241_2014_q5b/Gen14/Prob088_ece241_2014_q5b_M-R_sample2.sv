module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// State encoding: strictly one-hot
// state_A = 1 means state A, state_B = 1 means state B
reg state_A, state_B;

// Next state signals
reg next_state_A, next_state_B;

always @(*) begin
    // Default next state to current state (safe)
    next_state_A = state_A;
    next_state_B = state_B;

    // State transitions
    case ({state_A, state_B})
        2'b10: // state A
            if (x == 1'b0) begin
                next_state_A = 1'b1;
                next_state_B = 1'b0;
            end else begin
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end
        2'b01: // state B
            if (x == 1'b0) begin
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end else begin
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end
        default: begin
            // Undefined state, recover to state A
            next_state_A = 1'b1;
            next_state_B = 1'b0;
        end
    endcase
end

// State flip-flops with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1; // reset into state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Mealy output logic: combinationally depend on current state and input
always @(*) begin
    case ({state_A, state_B})
        2'b10: z = (x == 1'b1) ? 1'b1 : 1'b0; // state A: z=1 if x=1 else 0
        2'b01: z = (x == 1'b0) ? 1'b1 : 1'b0; // state B: z=1 if x=0 else 0
        default: z = 1'b0;
    endcase
end

endmodule