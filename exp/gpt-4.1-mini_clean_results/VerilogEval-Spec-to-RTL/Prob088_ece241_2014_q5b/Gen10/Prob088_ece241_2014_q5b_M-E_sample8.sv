module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded state flip-flops
reg state_A, state_B;

// Next state signals
reg next_state_A, next_state_B;

always @(*) begin
    // Default outputs and next states
    next_state_A = 1'b0;
    next_state_B = 1'b0;
    z = 1'b0;

    case ({state_A, state_B})
        2'b10: begin // State A
            if (x == 1'b0) begin
                next_state_A = 1'b1; // stay in A
                z = 1'b0;
            end else begin
                next_state_B = 1'b1; // go to B
                z = 1'b1;
            end
        end
        2'b01: begin // State B
            next_state_B = 1'b1; // stay in B
            if (x == 1'b0)
                z = 1'b1;
            else
                z = 1'b0;
        end
        default: begin
            // Safety: Default to state A if in invalid state
            next_state_A = 1'b1;
            z = 1'b0;
        end
    endcase
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1; // reset into state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule