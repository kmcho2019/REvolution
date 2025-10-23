module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,       // one-hot: bit0=S ... bit9=Wait
    output reg         B3_next,
    output reg         S_next,
    output reg         S1_next,
    output reg         Count_next,
    output reg         Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bit indices for reference
localparam S_BIT     = 0;
localparam S1_BIT    = 1;
localparam S11_BIT   = 2;
localparam S110_BIT  = 3;
localparam B0_BIT    = 4;
localparam B1_BIT    = 5;
localparam B2_BIT    = 6;
localparam B3_BIT    = 7;
localparam COUNT_BIT = 8;
localparam WAIT_BIT  = 9;

// Extract current state bits
wire [9:0] state_vec = state;

// Determine which state bit is active (one-hot) by priority encoder style.
// There will be exactly one bit set, but we decode position for case usage.
// If multiple bits set, lowest bit priority applies.
function [3:0] get_state_pos(input [9:0] st);
    integer i;
    begin
        get_state_pos = 0;
        for (i = 0; i < 10; i = i+1) begin
            if (st[i]) begin
                get_state_pos = i[3:0];
                disable for;
            end
        end
    end
endfunction

wire [3:0] current_state_pos = get_state_pos(state_vec);

// Default output assignments (reset all next states to 0)
always @(*) begin
    B3_next   = 1'b0;
    S_next    = 1'b0;
    S1_next   = 1'b0;
    Count_next= 1'b0;
    Wait_next = 1'b0;

    case (current_state_pos)
        // S (bit 0)
        S_BIT: begin
            if (d == 1'b0)
                S_next = 1'b1;
            else
                S1_next = 1'b1;
        end

        // S1 (bit 1)
        S1_BIT: begin
            if (d == 1'b0)
                S_next = 1'b1;
            else
                // S11 is bit 2
                // next state will be S11_next = 1
                S1_next = 1'b0; // explicitly, though default 0
                // We'll add S11_next = 1 here by using Count_next temporarily (or 
                // but S11_next is not a port, so just encode via S11_next local wire)
                // Instead, to reflect only the requested outputs, we only assert outputs 
                // for B3_next, S_next, S1_next, Count_next, Wait_next.
                // So we will leave S11 next state not expressed explicitly as output.
                // The problem only wants these 5 next-state signals output.
                // So we skip explicit S11_next in outputs as per problem statement.
                // No output asserted for S11 next.
        end

        // S11 (bit 2)
        S11_BIT: begin
            if (d == 1'b0)
                // next state S110 (bit 3) - no output requested for it.
                // So no next state output asserted.
                ;
            else
                // Stay in S11, no output asserted.
                ;
        end

        // S110 (bit 3)
        S110_BIT: begin
            if (d == 1'b0)
                S_next = 1'b1;
            else
                // next state B0 (bit 4) - no direct output port for B0_next, so no output asserted
                ;
        end

        // B0 (bit 4)
        B0_BIT: begin
            // always go to B1 next cycle
            // no output port for B1_next, so none asserted
            ;
        end

        // B1 (bit 5)
        B1_BIT: begin
            // always go to B2 next cycle
            ;
        end

        // B2 (bit 6)
        B2_BIT: begin
            // always go to B3 next cycle
            B3_next = 1'b1;
        end

        // B3 (bit 7)
        B3_BIT: begin
            // always go to Count next
            Count_next = 1'b1;
        end

        // Count (bit 8)
        COUNT_BIT: begin
            if (done_counting == 1'b0)
                Count_next = 1'b1;
            else
                Wait_next = 1'b1;
        end

        // Wait (bit 9)
        WAIT_BIT: begin
            if (ack == 1'b0)
                Wait_next = 1'b1;
            else
                S_next = 1'b1;
        end

        default: begin
            // Unknown state: go to S (reset safe)
            S_next = 1'b1;
        end
    endcase
end

// Outputs based on current state bits
assign done      = state[WAIT_BIT];
assign counting  = state[COUNT_BIT];
assign shift_ena = state[B0_BIT] | state[B1_BIT] | state[B2_BIT] | state[B3_BIT];

endmodule