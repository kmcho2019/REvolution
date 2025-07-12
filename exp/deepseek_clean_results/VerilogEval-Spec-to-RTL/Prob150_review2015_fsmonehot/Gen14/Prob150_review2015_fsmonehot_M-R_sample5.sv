module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
);

    // One-hot state encoding
    localparam S     = 10'b0000000001;
    localparam S1    = 10'b0000000010;
    localparam S11   = 10'b0000000100;
    localparam S110  = 10'b0000001000;
    localparam B0    = 10'b0000010000;
    localparam B1    = 10'b0000100000;
    localparam B2    = 10'b0001000000;
    localparam B3    = 10'b0010000000;
    localparam Count = 10'b0100000000;
    localparam Wait  = 10'b1000000000;

    always_comb begin
        // Default values
        B3_next = 1'b0;
        S_next = 1'b0;
        S1_next = 1'b0;
        Count_next = 1'b0;
        Wait_next = 1'b0;
        done = 1'b0;
        counting = 1'b0;
        shift_ena = 1'b0;

        casez (state)
            S: begin
                S_next = ~d;
                S1_next = d;
            end
            S1: begin
                S_next = ~d;
                if (d) S11 = 1'b1;  // Not shown in outputs but part of state machine
            end
            S11: begin
                if (~d) S110 = 1'b1;  // Not shown in outputs
                else S11 = 1'b1;      // Self-loop
            end
            S110: begin
                S_next = ~d;
                if (d) B0 = 1'b1;     // Not shown in outputs
            end
            B0: begin
                B1 = 1'b1;           // Not shown in outputs
                shift_ena = 1'b1;
            end
            B1: begin
                B2 = 1'b1;           // Not shown in outputs
                shift_ena = 1'b1;
            end
            B2: begin
                B3_next = 1'b1;
                shift_ena = 1'b1;
            end
            B3: begin
                Count_next = 1'b1;
                shift_ena = 1'b1;
            end
            Count: begin
                counting = 1'b1;
                if (done_counting) Wait_next = 1'b1;
                else Count_next = 1'b1;
            end
            Wait: begin
                done = 1'b1;
                if (ack) S_next = 1'b1;
                else Wait_next = 1'b1;
            end
            default: begin
                S_next = 1'b1;  // Default to S state
            end
        endcase
    end

endmodule