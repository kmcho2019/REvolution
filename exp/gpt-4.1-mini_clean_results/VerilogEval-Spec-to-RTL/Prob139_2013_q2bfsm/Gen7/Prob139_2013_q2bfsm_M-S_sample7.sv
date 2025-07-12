module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam [2:0]
        S_A   = 3'd0, // reset state
        S_B   = 3'd1, // f=1 pulse after reset release
        S_SEQ = 3'd2, // detect x=1,0,1 sequence (0,1,2 = seq step)
        S_MON = 3'd3, // g=1, monitor y up to 2 cycles
        S_G1  = 3'd4, // g=1 permanent
        S_G0  = 3'd5; // g=0 permanent

    reg [2:0] state, next_state;
    reg [1:0] seq_step, next_seq_step; // track progress in sequence x=1,0,1
    reg [1:0] mon_cnt, next_mon_cnt;

    // State and counters update on clock, synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state    <= S_A;
            seq_step <= 2'd0;
            mon_cnt  <= 2'd0;
        end else begin
            state    <= next_state;
            seq_step <= next_seq_step;
            mon_cnt  <= next_mon_cnt;
        end
    end

    // Next state and counters logic
    always @(*) begin
        // Defaults to hold current values
        next_state    = state;
        next_seq_step = seq_step;
        next_mon_cnt  = mon_cnt;

        case(state)
            S_A: begin
                // Stay in reset state while resetn=0
                if (resetn)
                    next_state = S_B;
                else
                    next_state = S_A;
                next_seq_step = 2'd0;
                next_mon_cnt  = 2'd0;
            end

            S_B: begin
                // One cycle pulse f=1 after reset release
                next_state    = S_SEQ;
                next_seq_step = 2'd0;
                next_mon_cnt  = 2'd0;
            end

            S_SEQ: begin
                // Sequence detector for x=1,0,1 with overlap support
                case(seq_step)
                    2'd0: // expect x=1
                        if (x)
                            next_seq_step = 2'd1;
                        else
                            next_seq_step = 2'd0;
                    2'd1: // expect x=0
                        if (!x)
                            next_seq_step = 2'd2;
                        else if (x) // restart sequence if x=1 again
                            next_seq_step = 2'd1;
                        else
                            next_seq_step = 2'd0; // defensive
                    2'd2: // expect x=1 to complete sequence
                        if (x) begin
                            next_state = S_MON; // detected sequence complete
                            next_seq_step = 2'd0;
                            next_mon_cnt = 2'd0;
                        end else if (!x) begin
                            // sequence broken, restart from beginning
                            next_seq_step = (x == 1'b1) ? 2'd1 : 2'd0;
                        end else
                            next_seq_step = 2'd0; // defensive
                    default:
                        next_seq_step = 2'd0;
                endcase
                // mon_cnt not used here
                next_mon_cnt = 2'd0;
            end

            S_MON: begin
                // g=1, monitor y for up to 2 cycles
                if (y) begin
                    next_state = S_G1; // y=1 seen, g=1 permanently
                    next_mon_cnt = 2'd0;
                end else if (mon_cnt == 2'd1) begin
                    // after two cycles (0 and 1), no y=1
                    next_state = S_G0; // g=0 permanently
                    next_mon_cnt = 2'd0;
                end else begin
                    // Continue monitoring, increment counter
                    next_state   = S_MON;
                    next_mon_cnt = mon_cnt + 1'b1;
                end
                next_seq_step = 2'd0;
            end

            S_G1: begin
                // g=1 permanently until reset
                next_state    = S_G1;
                next_seq_step = 2'd0;
                next_mon_cnt  = 2'd0;
            end

            S_G0: begin
                // g=0 permanently until reset
                next_state    = S_G0;
                next_seq_step = 2'd0;
                next_mon_cnt  = 2'd0;
            end

            default: begin
                next_state    = S_A;
                next_seq_step = 2'd0;
                next_mon_cnt  = 2'd0;
            end
        endcase
    end

    // Moore outputs based on state only
    always @(*) begin
        f = 1'b0;
        g = 1'b0;
        case(state)
            S_B:   f = 1'b1;
            S_MON,
            S_G1:  g = 1'b1;
            default: begin end
        endcase
    end

endmodule