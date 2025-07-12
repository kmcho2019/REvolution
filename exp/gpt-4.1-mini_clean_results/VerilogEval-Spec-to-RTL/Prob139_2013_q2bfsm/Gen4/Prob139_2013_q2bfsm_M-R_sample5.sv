module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum logic [2:0] {
        S_A      = 3'd0, // Reset state
        S_B      = 3'd1, // f=1 one cycle after reset release
        S_SEQ0   = 3'd2, // Wait for x=1 start seq
        S_SEQ1   = 3'd3, // Wait for x=0
        S_SEQ2   = 3'd4, // Wait for x=1, seq done -> monitor y
        S_MON    = 3'd5, // g=1, monitor y for 2 cycles
        S_G1     = 3'd6, // g=1 permanently
        S_G0     = 3'd7  // g=0 permanently
    } state_t;

    state_t state, next_state;
    reg [1:0] mon_cnt, next_mon_cnt;

    // Sequential block: state and counter update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= S_A;
            mon_cnt <= 2'd0;
        end else begin
            state   <= next_state;
            mon_cnt <= next_mon_cnt;
        end
    end

    // Combinational block: next state and mon_cnt logic
    always @(*) begin
        // Default assignments
        next_state   = state;
        next_mon_cnt = mon_cnt;

        case(state)
            S_A: begin
                if (resetn)
                    next_state = S_B;
                else
                    next_state = S_A;
                next_mon_cnt = 2'd0;
            end

            S_B: begin
                next_state = S_SEQ0;
                next_mon_cnt = 2'd0;
            end

            S_SEQ0: begin
                if (x)
                    next_state = S_SEQ1;
                else
                    next_state = S_SEQ0;
                next_mon_cnt = 2'd0;
            end

            S_SEQ1: begin
                if (!x)
                    next_state = S_SEQ2;
                else
                    next_state = S_SEQ1;
                next_mon_cnt = 2'd0;
            end

            S_SEQ2: begin
                if (x)
                    next_state = S_MON; // sequence detected
                else
                    next_state = S_SEQ0;
                next_mon_cnt = 2'd0;
            end

            S_MON: begin
                if (y)
                    next_state = S_G1;
                else if (mon_cnt == 2'd1)
                    next_state = S_G0;
                else
                    next_state = S_MON;

                if (next_state == S_MON)
                    next_mon_cnt = mon_cnt + 1'b1;
                else
                    next_mon_cnt = 2'd0;
            end

            S_G1: begin
                next_state = S_G1;  // hold g=1 permanently
                next_mon_cnt = 2'd0;
            end

            S_G0: begin
                next_state = S_G0;  // hold g=0 permanently
                next_mon_cnt = 2'd0;
            end

            default: begin
                next_state = S_A;
                next_mon_cnt = 2'd0;
            end
        endcase
    end

    // Output combinational logic: Moore outputs based on current state
    always @(*) begin
        case(state)
            S_B: begin
                f = 1'b1;
                g = 1'b0;
            end

            S_MON, S_G1: begin
                f = 1'b0;
                g = 1'b1;
            end

            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule