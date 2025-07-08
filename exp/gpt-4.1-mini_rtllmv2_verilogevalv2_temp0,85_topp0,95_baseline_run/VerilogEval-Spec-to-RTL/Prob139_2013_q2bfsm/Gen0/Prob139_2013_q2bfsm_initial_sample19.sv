module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0,   // initial state after reset
        B = 3'd1,   // output f=1 one cycle
        C0 = 3'd2,  // waiting for x=1 (first bit)
        C1 = 3'd3,  // waiting for x=0 (second bit)
        C2 = 3'd4,  // waiting for x=1 (third bit)
        D = 3'd5,   // g=1, wait for y within 2 cycles
        E = 3'd6,   // g=1 permanent
        F = 3'd7    // g=0 permanent
    } state_t;

    reg [2:0] state, next_state;
    reg [1:0] y_count; // counts clocks in state D waiting for y

    // State register
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        // default next state is current state
        next_state = state;
        case(state)
            A: begin
                if (resetn)
                    next_state = B;
            end
            B: begin
                next_state = C0;
            end
            C0: begin
                // Wait for x=1 as first bit
                if (x == 1'b1)
                    next_state = C1;
                else
                    next_state = C0; // keep waiting
            end
            C1: begin
                // Wait for x=0 as second bit
                if (x == 1'b0)
                    next_state = C2;
                else if (x == 1'b1)
                    next_state = C1; // still waiting for 0, but if x=1 stays here, could reset sequence too, but requirement is strict 101 so we can treat other values as restart from C0 or C1. To be safe let's restart sequence if not matching.
                else
                    next_state = C0; // fallback to C0 to restart sequence if x isn't 0 or 1 (only 1-bit input, so else case never occurs)
            end
            C2: begin
                // Wait for x=1 as third bit
                if (x == 1'b1)
                    next_state = D;
                else if (x == 1'b0)
                    next_state = C0; // restart sequence
                else
                    next_state = C0;
            end
            D: begin
                // Wait up to two cycles for y=1
                // If y==1 => go to E (permanent g=1)
                // else if 2 cycles elapsed => go to F (permanent g=0)
                if (y == 1'b1)
                    next_state = E;
                else if (y_count == 2)
                    next_state = F;
                else
                    next_state = D;
            end
            E: begin
                // permanent g=1 until reset
                next_state = E;
            end
            F: begin
                // permanent g=0 until reset
                next_state = F;
            end
            default: next_state = A;
        endcase
    end

    // y_count update and output logic
    always @(posedge clk) begin
        if (~resetn) begin
            f <= 1'b0;
            g <= 1'b0;
            y_count <= 2'd0;
        end else begin
            case(state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'd0;
                end
                B: begin
                    f <= 1'b1;  // f=1 for one cycle
                    g <= 1'b0;
                    y_count <= 2'd0;
                end
                C0, C1, C2: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'd0;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    if (y == 1'b1)
                        y_count <= 2'd0; // reset, will transition to E next cycle
                    else if (y_count < 2)
                        y_count <= y_count + 1;
                end
                E: begin
                    f <= 1'b0;
                    g <= 1'b1;
                    y_count <= 2'd0;
                end
                F: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'd0;
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'd0;
                end
            endcase
        end
    end

endmodule