module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // Define states
    typedef enum reg [2:0] {
        A = 3'd0, // reset state
        B = 3'd1, // f=1 for one cycle after reset released
        C0 = 3'd2, // waiting for first x=1 of 101
        C1 = 3'd3, // got x=1, waiting for x=0
        C2 = 3'd4, // got x=1,0, waiting for x=1
        D = 3'd5, // g=1, monitor y for 2 cycles
        E = 3'd6  // g=0 permanent after fail to see y=1 in 2 cycles
    } state_t;

    state_t state, next_state;

    reg [1:0] y_count; // counts cycles in D monitoring y

    // Sequential logic - state and output update
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            y_count <= 0;
        end else begin
            state <= next_state;

            case (next_state)
                A: begin
                    f <= 0;
                    g <= 0;
                    y_count <= 0;
                end
                B: begin
                    f <= 1;    // f=1 for one cycle after reset released
                    g <= 0;
                    y_count <= 0;
                end
                C0: begin
                    f <= 0;
                    g <= 0;
                    y_count <= 0;
                end
                C1: begin
                    f <= 0;
                    g <= 0;
                    y_count <= 0;
                end
                C2: begin
                    f <= 0;
                    g <= 0;
                    y_count <= 0;
                end
                D: begin
                    f <= 0;
                    g <= 1;
                    // y_count updated below
                end
                E: begin
                    f <= 0;
                    g <= 0;
                    y_count <= 0;
                end
                default: begin
                    f <= 0;
                    g <= 0;
                    y_count <= 0;
                end
            endcase

            // Update y_count only in state D
            if (next_state == D) begin
                if (state == D) begin
                    // increment count if y not seen
                    if (y == 1)
                        y_count <= 0; // reset if y=1
                    else if (y_count < 2)
                        y_count <= y_count + 1;
                    else
                        y_count <= y_count; // saturate at 2
                end else begin
                    // entered D fresh, reset count
                    y_count <= 0;
                end
            end else begin
                y_count <= 0;
            end
        end
    end

    // Combinational logic - next state logic
    always @(*) begin
        next_state = state;
        case(state)
            A: begin
                // Wait in A while resetn is 0, else move to B
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // After one cycle of f=1, move to monitor sequence
                next_state = C0;
            end
            C0: begin
                // looking for first x=1 in sequence 101
                if (x == 1)
                    next_state = C1;
                else
                    next_state = C0;
            end
            C1: begin
                // got x=1, now wait for x=0
                if (x == 0)
                    next_state = C2;
                else if (x == 1)
                    next_state = C1; // remain waiting for 0
                else
                    next_state = C0; // fallback to searching x=1 again
            end
            C2: begin
                // got x=1,0 now wait for x=1
                if (x == 1)
                    next_state = D;
                else
                    next_state = C0; // restart sequence if x != 1 here
            end
            D: begin
                // g=1, monitor y for up to two cycles
                if (y == 1) begin
                    // y seen: stay in D with g=1 permanently
                    next_state = D;
                end else if (y_count >= 2) begin
                    // y not seen within two cycles, g=0 permanently
                    next_state = E;
                end else begin
                    // continue monitoring y
                    next_state = D;
                end
            end
            E: begin
                // g=0 permanently until reset
                next_state = E;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

endmodule