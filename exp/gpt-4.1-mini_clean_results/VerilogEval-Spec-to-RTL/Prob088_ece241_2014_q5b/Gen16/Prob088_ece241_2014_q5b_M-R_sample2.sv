module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state_A, state_B;
reg next_state_A, next_state_B;

// Next state and output logic combinational block
always @(*) begin
    // Default values
    next_state_A = 1'b0;
    next_state_B = 1'b0;
    z = 1'b0;

    case ({state_A, state_B})
        2'b10: begin  // State A
            if (x == 1'b0) begin
                next_state_A = 1'b1; // Stay in A
                z = 1'b0;
            end else begin
                next_state_B = 1'b1; // Transition to B
                z = 1'b1;
            end
        end
        2'b01: begin  // State B
            next_state_B = 1'b1; // Stay in B
            if (x == 1'b0)
                z = 1'b1;
            else
                z = 1'b0;
        end
        default: begin
            // Should not happen, reset to A state outputs
            next_state_A = 1'b1;
            z = 1'b0;
        end
    endcase
end

// State flip-flops with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule