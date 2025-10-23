module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states of the FSM
enum logic [1:0] {
    A,  // Reset state
    B,  // State after reset de-assertion
    C,  // Waiting for x sequence
    D,  // g is high, waiting for y
    E   // Permanent g high state
} state, next_state;

// Variables to track x sequence and g high cycles
reg [1:0] x_seq;
reg [1:0] g_high_cycles;

always @(*) begin
    // Default next state is current state
    next_state = state;

    case(state)
        A: begin
            if (!resetn) next_state = A; // Stay in A if resetn is low
            else next_state = B; // Move to B after reset de-assertion
        end
        B: next_state = C; // Move to C after one clock cycle
        C: begin
            if (x_seq == 2'b101) next_state = D; // Move to D if x sequence is 1,0,1
            else next_state = C; // Stay in C if x sequence is not 1,0,1
        end
        D: begin
            if (y || g_high_cycles == 2) next_state = E; // Move to E if y is high or g has been high for 2 cycles
            else if (g_high_cycles < 2) next_state = D; // Stay in D if g has not been high for 2 cycles
        end
        E: next_state = E; // Stay in E permanently
    endcase
end

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        x_seq <= 0;
        g_high_cycles <= 0;
    end else begin
        state <= next_state;

        case(state)
            A: begin
                f <= 0;
                g <= 0;
                x_seq <= 0;
                g_high_cycles <= 0;
            end
            B: begin
                f <= 1;
                g <= 0;
                x_seq <= 0;
                g_high_cycles <= 0;
            end
            C: begin
                f <= 0;
                g <= 0;
                if (x) x_seq <= {1'b1, x_seq[0]};
                else x_seq <= {1'b0, x_seq[0]};
                g_high_cycles <= 0;
            end
            D: begin
                f <= 0;
                g <= 1;
                x_seq <= 0;
                g_high_cycles <= g_high_cycles + 1;
            end
            E: begin
                f <= 0;
                g <= 1;
                x_seq <= 0;
                g_high_cycles <= 0;
            end
        endcase
    end
end

endmodule