module TopModule (
    input        d,
    input        done_counting,
    input        ack,
    input  [9:0] state,      // One-hot encoded: bit0=S, bit1=S1, ..., bit9=Wait
    output reg   B3_next,
    output reg   S_next,
    output reg   S1_next,
    output reg   Count_next,
    output reg   Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

    // State bit indices
    localparam S_BIT    = 0;
    localparam S1_BIT   = 1;
    localparam S11_BIT  = 2;
    localparam S110_BIT = 3;
    localparam B0_BIT   = 4;
    localparam B1_BIT   = 5;
    localparam B2_BIT   = 6;
    localparam B3_BIT   = 7;
    localparam COUNT_BIT= 8;
    localparam WAIT_BIT = 9;

    // Extract one-hot current state signals
    wire S     = state[S_BIT];
    wire S1    = state[S1_BIT];
    wire S11   = state[S11_BIT];
    wire S110  = state[S110_BIT];
    wire B0    = state[B0_BIT];
    wire B1    = state[B1_BIT];
    wire B2    = state[B2_BIT];
    wire B3    = state[B3_BIT];
    wire Count = state[COUNT_BIT];
    wire Wait  = state[WAIT_BIT];

    // Combinational next-state logic block
    always @(*) begin
        // Default: all next states deasserted
        B3_next    = 1'b0;
        S_next     = 1'b0;
        S1_next    = 1'b0;
        Count_next = 1'b0;
        Wait_next  = 1'b0;

        case (1'b1) // case on active one-hot state
            S: begin
                if (d == 1'b0)
                    S_next = 1'b1;
                else
                    S1_next = 1'b1;
            end
            S1: begin
                if (d == 1'b0)
                    S_next = 1'b1;
                else
                    // Next state S11 is not required output, so no signal set
                    // But since not asked, leave signals zero here
                    ;
            end
            S11: begin
                if (d == 1'b0)
                    // Next state S110, not requested as output
                    ;
                else
                    // Stay in S11, not requested as output
                    ;
            end
            S110: begin
                if (d == 1'b0)
                    S_next = 1'b1;
                else
                    // B0 next state not requested as output signals
                    ;
            end
            B0: begin
                // Always advance to B1 (not requested)
            end
            B1: begin
                // Always advance to B2 (not requested)
            end
            B2: begin
                // Always advance to B3
                B3_next = 1'b1;
            end
            B3: begin
                // Always advance to Count
                Count_next = 1'b1;
            end
            Count: begin
                if (done_counting == 1'b0)
                    Count_next = 1'b1;
                else
                    Wait_next = 1'b1;
            end
            Wait: begin
                if (ack == 1'b0)
                    Wait_next = 1'b1;
                else
                    S_next = 1'b1;
            end
            default: begin
                // If no valid state bit set, default to S next state
                S_next = 1'b1;
            end
        endcase
    end

    // Output logic (Moore: outputs depend on current state)
    assign done      = Wait;
    assign counting  = Count;
    assign shift_ena = B0 | B1 | B2 | B3;

endmodule