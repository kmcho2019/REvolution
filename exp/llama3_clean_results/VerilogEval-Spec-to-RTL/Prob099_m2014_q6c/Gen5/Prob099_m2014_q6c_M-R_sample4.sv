module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Define a variable for the next-state logic
logic Y1_next, Y3_next;

always_comb begin
    // Initialize next-state signals to 0
    Y1_next = 1'b0;
    Y3_next = 1'b0;

    // Determine the next state based on the current state and input
    case (1'b1)
        y[0]: begin // State A
            if (~w) Y1_next = 1'b1; // Transition to B on w=0
            else Y1_next = 1'b0; // Stay in A on w=1
            if (~w) Y3_next = 1'b0; // No transition to D from A on w=0
            else Y3_next = 1'b0; // No transition to D from A on w=1
        end
        y[1]: begin // State B
            if (~w) Y1_next = 1'b0; // Transition to C on w=0
            else Y1_next = 1'b1; // Stay in B on w=1, but since we are calculating Y1, it should go to D
            Y1_next = (y[1] & w); // Transition to D on w=1
            if (~w) Y3_next = 1'b0; // No direct transition to D from B on w=0
            else Y3_next = 1'b1; // Transition to D on w=1
        end
        y[2]: begin // State C
            if (~w) Y1_next = 1'b0; // Transition to E on w=0
            else Y1_next = 1'b0; // Transition to D on w=1
            if (~w) Y3_next = 1'b0; // No direct transition to D from C on w=0
            else Y3_next = 1'b1; // Transition to D on w=1
        end
        y[3]: begin // State D
            if (~w) Y1_next = 1'b0; // Transition to F on w=0
            else Y1_next = 1'b0; // Transition back to A on w=1
            Y1_next = (y[0] & w) | (y[3] & w); // Aggregate transitions to B or staying in D
            if (~w) Y3_next = 1'b0; // Transition to F on w=0
            else Y3_next = 1'b0; // Transition back to A on w=1
        end
        y[4]: begin // State E
            if (~w) Y1_next = 1'b0; // Stay in E on w=0
            else Y1_next = 1'b0; // Transition to D on w=1
            if (~w) Y3_next = 1'b0; // Stay in E on w=0
            else Y3_next = 1'b1; // Transition to D on w=1
        end
        y[5]: begin // State F
            if (~w) Y1_next = 1'b0; // Transition back to C on w=0
            else Y1_next = 1'b0; // Transition to D on w=1
            if (~w) Y3_next = 1'b0; // Transition back to C on w=0
            else Y3_next = 1'b1; // Transition to D on w=1
        end
        default: begin
            Y1_next = 1'b0;
            Y3_next = 1'b0;
        end
    endcase

    // Assign next-state signals to outputs
    Y1 = Y1_next;
    Y3 = Y3_next;
end

endmodule