module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// State encoding (one-hot)
reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state logic
always @(*) begin
    // Default assignments
    next_state_A = state_A;
    next_state_B = state_B;
    case ({state_A, state_B})
        2'b10: begin // State A
            if (x == 1'b1) begin
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end else begin
                next_state_A = 1'b1;
                next_state_B = 1'b0;
            end
        end
        2'b01: begin // State B
            // Stay in B regardless of x
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end
        default: begin // Invalid or reset states
            next_state_A = 1'b1;
            next_state_B = 1'b0;
        end
    endcase
end

// State registers with async active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;  // reset to state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Output logic (Mealy): z=1 when (A and x=1) or (B and x=0)
assign z = (state_A & x) | (state_B & ~x);

endmodule