module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
enum logic [2:0] {A, B, C, D, E, F} state, next_state;

// Initialize state and outputs
initial begin
    state = A;
    f = 0;
    g = 0;
end

// State transitions and output logic
always @(*) begin
    case (state)
        A: begin
            if (~resetn) begin
                next_state = A;
                f = 0;
                g = 0;
            end else begin
                next_state = B;
                f = 1;
                g = 0;
            end
        end
        B: begin
            next_state = C;
            f = 0;
            g = 0;
        end
        C: begin
            // Sequence detection for x: 1, 0, 1
            static logic [1:0] x_seq = 0;
            case (x_seq)
                0: begin
                    if (x) x_seq = 1; // 1xx
                    else x_seq = 0; // 0xx
                end
                1: begin
                    if (~x) x_seq = 2; // 10x
                    else x_seq = 1; // 11x
                end
                2: begin
                    if (x) x_seq = 3; // 101
                    else x_seq = 0; // 100
                end
                3: begin
                    x_seq = 3; // Sequence detected, stay here until next state
                    next_state = D;
                    g = 1;
                end
            endcase
        end
        D: begin
            // Monitor y for up to two cycles
            static logic [1:0] y_count = 0;
            g = 1;
            if (y) begin
                next_state = E;
            end else if (y_count < 2) begin
                y_count++;
                next_state = D;
            end else begin
                next_state = F;
            end
        end
        E: begin
            next_state = E;
            g = 1;
        end
        F: begin
            next_state = F;
            g = 0;
        end
        default: next_state = A;
    endcase
end

// Update state on positive clock edge
always @(posedge clk) begin
    if (~resetn) state <= A;
    else state <= next_state;
end

endmodule