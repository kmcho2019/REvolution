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
        A = 3'd0,   // Reset state
        B = 3'd1,   // Pulse f=1 for one cycle
        C = 3'd2,   // Monitor x for sequence 101
        D = 3'd3,   // g=1, monitor y for up to 2 cycles
        E = 3'd4,   // Hold g=1 forever
        F = 3'd5    // Hold g=0 forever
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;      // Shift register for last 3 x samples
    reg [1:0] y_count;      // Count cycles waiting for y=1 in state D

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Update x_shift only in states after B (start monitoring in C and beyond)
            if (state >= C)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000;

            // Update y_count only in state D
            if (state == D)
                y_count <= y_count + 1'b1;
            else
                y_count <= 2'd0;

            // Outputs depend only on current state (Moore FSM)
            case (state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                B: begin
                    f <= 1'b1;
                    g <= 1'b0;
                end
                C: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                E: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                F: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            A: begin
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // After one cycle pulse on f, move to monitor x
                next_state = C;
            end
            C: begin
                // Detect sequence 101 on x_shift
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                if (y == 1'b1)
                    next_state = E;    // y detected in time
                else if (y_count == 2'd2)
                    next_state = F;    // timeout without y=1
                else
                    next_state = D;    // keep waiting
            end
            E: begin
                if (!resetn)
                    next_state = A;
                else
                    next_state = E;
            end
            F: begin
                if (!resetn)
                    next_state = A;
                else
                    next_state = F;
            end
            default: next_state = A;
        endcase
    end

endmodule