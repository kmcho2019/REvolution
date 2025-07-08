module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
typedef enum logic [2:0] {
    A = 3'd0, // reset state
    B = 3'd1, // f=1 for one cycle after resetn deasserted
    C1 = 3'd2, // wait for x=1 (first sequence bit)
    C2 = 3'd3, // wait for x=0 (second sequence bit)
    C3 = 3'd4, // wait for x=1 (third sequence bit)
    D = 3'd5,  // g=1, monitor y for up to two cycles
    E = 3'd6,  // g=1 permanently
    F = 3'd7   // g=0 permanently
} state_t;

state_t state, next_state;
reg [1:0] y_wait_cnt; // counter for y monitoring in state D

// State register update
always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
        y_wait_cnt <= 2'd0;
    end else begin
        state <= next_state;

        // Default outputs
        f <= 0;

        case(next_state)
            B: f <= 1; // output f=1 for one cycle
            D: g <= 1; // g=1 while monitoring y
            E: g <= 1; // g=1 permanently
            F: g <= 0; // g=0 permanently
            default: begin
                if (state != D && state != E && state != F)
                    g <= 0;
            end
        endcase

        // Update y_wait_cnt in state D
        if (state == D) begin
            y_wait_cnt <= y_wait_cnt + 1;
        end else begin
            y_wait_cnt <= 2'd0;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case(state)
        A: begin
            // stay here while resetn is low
            if (resetn) next_state = B;
        end
        B: begin
            // after one cycle f=1, start monitoring x sequence
            if (resetn) next_state = C1;
            else next_state = A;
        end
        C1: begin
            // wait for x=1 first bit
            if (~resetn) next_state = A;
            else if (x == 1) next_state = C2;
            else next_state = C1;
        end
        C2: begin
            // wait for x=0 second bit
            if (~resetn) next_state = A;
            else if (x == 0) next_state = C3;
            else if (x == 1) next_state = C2; // stay or re-sync
            else next_state = C1; // restart sequence if invalid
        end
        C3: begin
            // wait for x=1 third bit
            if (~resetn) next_state = A;
            else if (x == 1) next_state = D;
            else if (x == 0) next_state = C1; // restart sequence
            else next_state = C1;
        end
        D: begin
            // g=1, monitor y for up to two cycles
            if (~resetn) next_state = A;
            else if (y == 1) next_state = E;
            else if (y_wait_cnt == 2) next_state = F;
            else next_state = D;
        end
        E: begin
            // g=1 permanently until reset
            if (~resetn) next_state = A;
            else next_state = E;
        end
        F: begin
            // g=0 permanently until reset
            if (~resetn) next_state = A;
            else next_state = F;
        end
        default: next_state = A;
    endcase
end

endmodule