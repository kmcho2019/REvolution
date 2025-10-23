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
    output reg         done,
    output reg         counting,
    output reg         shift_ena
);

// State bit indices for readability
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

localparam S_STATE    = 10'b0000000001;
localparam S1_STATE   = 10'b0000000010;
localparam S11_STATE  = 10'b0000000100;
localparam S110_STATE = 10'b0000001000;
localparam B0_STATE   = 10'b0000010000;
localparam B1_STATE   = 10'b0000100000;
localparam B2_STATE   = 10'b0001000000;
localparam B3_STATE   = 10'b0010000000;
localparam COUNT_STATE= 10'b0100000000;
localparam WAIT_STATE = 10'b1000000000;

always @(*) begin
    // Default values for all outputs
    B3_next    = 1'b0;
    S_next     = 1'b0;
    S1_next    = 1'b0;
    Count_next = 1'b0;
    Wait_next  = 1'b0;
    done       = 1'b0;
    counting   = 1'b0;
    shift_ena  = 1'b0;

    casez (state)
        S_STATE: begin
            // From S:
            // d=0 -> S
            // d=1 -> S1
            if (d == 1'b0) begin
                S_next = 1'b1;
            end else begin
                S1_next = 1'b1;
            end
        end

        S1_STATE: begin
            // From S1:
            // d=0 -> S
            // d=1 -> S11
            if (d == 1'b0) begin
                S_next = 1'b1;
            end else begin
                // S11 is internal state, no output port for S11_next
                // so no output assigned here
            end
        end

        S11_STATE: begin
            // From S11:
            // d=0 -> S110
            // d=1 -> S11 (self loop)
            // No next state outputs for S11 or S110 given in interface, so do nothing
        end

        S110_STATE: begin
            // From S110:
            // d=0 -> S
            // d=1 -> B0
            if (d == 1'b0) begin
                S_next = 1'b1;
            end else begin
                // B0 is internal state, no output port for B0_next
            end
        end

        B0_STATE: begin
            // From B0 -> B1 (always)
            // shift_ena = 1
            shift_ena = 1'b1;
            // B1_next not output
        end

        B1_STATE: begin
            // From B1 -> B2 (always)
            // shift_ena = 1
            shift_ena = 1'b1;
            // B2_next not output
        end

        B2_STATE: begin
            // From B2 -> B3 (always)
            // shift_ena = 1
            shift_ena = 1'b1;
            B3_next = 1'b1;
        end

        B3_STATE: begin
            // From B3 -> Count (always)
            // shift_ena = 1
            shift_ena = 1'b1;
            Count_next = 1'b1;
        end

        COUNT_STATE: begin
            // counting=1
            counting = 1'b1;
            // done_counting=0 -> Count (self loop)
            // done_counting=1 -> Wait
            if (done_counting == 1'b0) begin
                Count_next = 1'b1;
            end else begin
                Wait_next = 1'b1;
            end
        end

        WAIT_STATE: begin
            // done=1
            done = 1'b1;
            // ack=0 -> Wait (self loop)
            // ack=1 -> S
            if (ack == 1'b0) begin
                Wait_next = 1'b1;
            end else begin
                S_next = 1'b1;
            end
        end

        default: begin
            // Should not happen for one-hot encoding
            // All outputs default to zero
        end
    endcase
end

endmodule