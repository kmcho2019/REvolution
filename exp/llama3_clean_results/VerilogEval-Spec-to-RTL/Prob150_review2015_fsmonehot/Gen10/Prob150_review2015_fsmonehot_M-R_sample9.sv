module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Current state
    wire S     = state[0];
    wire S1    = state[1];
    wire S11   = state[2];
    wire S110  = state[3];
    wire B0    = state[4];
    wire B1    = state[5];
    wire B2    = state[6];
    wire B3    = state[7];
    wire Count = state[8];
    wire Wait  = state[9];

    // Internal signals for next-state and output logic
    reg B3_next_int;
    reg S_next_int;
    reg S1_next_int;
    reg Count_next_int;
    reg Wait_next_int;
    reg done_int;
    reg counting_int;
    reg shift_ena_int;

    always @(*) begin
        case (1'b1)  // Using 1'b1 to always enter the case statement
            S: begin
                if (~d) begin
                    S_next_int = 1'b1;
                end else begin
                    S1_next_int = 1'b1;
                end
            end
            S1: begin
                if (~d) begin
                    S_next_int = 1'b1;
                end else begin
                    // Implicitly goes to S11, handled by default assignments
                end
            end
            S11: begin
                if (~d) begin
                    S110_int = 1'b1;
                end else begin
                    // Stays in S11
                    // No need for explicit assignment, as it's handled by default
                end
            end
            S110: begin
                if (~d) begin
                    S_next_int = 1'b1;
                end else begin
                    B0_int = 1'b1;  // Goes to B0
                end
            end
            B0, B1, B2, B3: begin
                shift_ena_int = 1'b1;
                if (&state[7:4]) begin  // If in B3
                    Count_next_int = 1'b1;
                end else if (state[6]) begin  // If in B2
                    B3_next_int = 1'b1;
                end else if (state[5]) begin  // If in B1
                    // Goes to B2
                    // No need for explicit assignment, handled by default
                end else begin  // If in B0
                    // Goes to B1
                    // No need for explicit assignment, handled by default
                end
            end
            Count: begin
                counting_int = 1'b1;
                if (done_counting) begin
                    Wait_next_int = 1'b1;
                end
            end
            Wait: begin
                done_int = 1'b1;
                if (ack) begin
                    S_next_int = 1'b1;
                end
            end
            default: begin
                // Default assignments to ensure all signals have a defined value
                // This is crucial for preventing latches
                S_next_int = 1'b0;
                S1_next_int = 1'b0;
                Count_next_int = 1'b0;
                Wait_next_int = 1'b0;
                done_int = 1'b0;
                counting_int = 1'b0;
                shift_ena_int = 1'b0;
                B3_next_int = 1'b0;
            end
        endcase

        // Assign internal signals to outputs
        assign B3_next = B3_next_int;
        assign S_next = S_next_int;
        assign S1_next = S1_next_int;
        assign Count_next = Count_next_int;
        assign Wait_next = Wait_next_int;
        assign done = done_int;
        assign counting = counting_int;
        assign shift_ena = shift_ena_int;
    end

endmodule