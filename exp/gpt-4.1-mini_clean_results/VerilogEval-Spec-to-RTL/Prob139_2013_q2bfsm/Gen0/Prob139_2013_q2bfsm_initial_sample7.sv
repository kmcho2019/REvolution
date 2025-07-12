module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0, // Reset state
        B = 3'd1, // Output f=1 for one cycle after reset
        C = 3'd2, // Monitor x sequence (1,0,1)
        D = 3'd3, // g=1, monitor y for up to 2 cycles
        E = 3'd4  // g=0 permanently after y not detected
    } state_t;

    state_t state, next_state;

    // For detecting x sequence 1,0,1 - use a small sequence detector FSM
    // x_seq_state:
    // 0 - waiting for first '1'
    // 1 - first '1' detected, waiting for '0'
    // 2 - '10' detected, waiting for final '1'
    // 3 - full sequence detected
    typedef enum logic [1:0] {
        X_SEQ_0 = 2'd0,
        X_SEQ_1 = 2'd1,
        X_SEQ_10 = 2'd2
    } x_seq_state_t;

    x_seq_state_t x_seq_state, x_seq_state_next;

    // Counter for monitoring y for at most 2 cycles after g=1 asserted
    reg [1:0] y_counter; // counts up to 2

    // Sequential logic: state registers and counters
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_seq_state <= X_SEQ_0;
            y_counter <= 2'd0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;
            x_seq_state <= x_seq_state_next;

            // Outputs updated below in combinational block for clarity except f and g controlled here:

            // f is only high for one cycle in state B
            // g controlled per state (set here)
            case (next_state)
                B: f <= 1'b1;
                default: f <= 1'b0;
            endcase

            case (next_state)
                D: g <= 1'b1;
                E: g <= 1'b0;
                default: g <= 1'b0;
            endcase

            // Manage y_counter only in state D (monitoring y)
            if (state == D) begin
                y_counter <= y_counter + 2'd1;
            end else begin
                y_counter <= 2'd0;
            end
        end
    end

    // Combinational logic for next_state and x_seq_state_next
    always @(*) begin
        next_state = state;
        x_seq_state_next = x_seq_state;

        case (state)
            A: begin
                // Wait for resetn de-asserted on clock edge to go to B
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // One cycle with f=1, then move to C to monitor x
                next_state = C;
            end

            C: begin
                // Monitor x sequence 1,0,1 using x_seq_state
                // Update x_seq_state_next accordingly

                case (x_seq_state)
                    X_SEQ_0: begin
                        if (x == 1'b1)
                            x_seq_state_next = X_SEQ_1;
                        else
                            x_seq_state_next = X_SEQ_0;
                    end
                    X_SEQ_1: begin
                        if (x == 1'b0)
                            x_seq_state_next = X_SEQ_10;
                        else if (x == 1'b1)
                            x_seq_state_next = X_SEQ_1; // stay here, still got first '1'
                        else
                            x_seq_state_next = X_SEQ_0;
                    end
                    X_SEQ_10: begin
                        if (x == 1'b1)
                            // sequence 1,0,1 detected
                            next_state = D;
                        else if (x == 1'b0)
                            x_seq_state_next = X_SEQ_0;
                        else
                            x_seq_state_next = X_SEQ_0;
                    end
                    default: x_seq_state_next = X_SEQ_0;
                endcase
            end

            D: begin
                // g=1 output maintained here
                // Monitor y for at most 2 clock cycles
                // If y==1 within 2 cycles => stay in D permanently
                // Else after 2 cycles with no y==1 => go to E with g=0 permanently

                if (y == 1'b1) begin
                    // y detected, stay in D permanently
                    next_state = D;
                end else begin
                    if (y_counter >= 2'd2) begin
                        // did not detect y within 2 cycles, go to E
                        next_state = E;
                    end else begin
                        // still within 2 cycles, remain in D
                        next_state = D;
                    end
                end
            end

            E: begin
                // g=0 permanently until reset
                next_state = E;
            end

            default: next_state = A;
        endcase
    end

endmodule