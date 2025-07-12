module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
typedef enum reg [2:0] {
    A = 3'd0, // Reset state
    B = 3'd1, // f=1 one cycle
    C0= 3'd2, // waiting for x=1 (start of sequence)
    C1= 3'd3, // x=0
    C2= 3'd4, // x=1
    D = 3'd5, // g=1 monitoring y for 2 cycles
    E = 3'd6, // g=1 permanent success
    F = 3'd7  // g=0 permanent fail
} state_t;

reg [2:0] state, next_state;

// Counter for monitoring y in state D (2 cycles max)
reg [1:0] y_counter;

// Sequential logic for state and y_counter
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        y_counter <= 2'd0;
    end else begin
        state <= next_state;
        if(state == D) begin
            y_counter <= y_counter + 1;
        end else begin
            y_counter <= 2'd0;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state; // default hold
    case(state)
        A: begin
            if (resetn) next_state = B;
        end
        B: begin
            next_state = C0;
        end
        C0: begin
            if (x == 1'b1)
                next_state = C1;
            else
                next_state = C0;
        end
        C1: begin
            if (x == 1'b0)
                next_state = C2;
            else if (x == 1'b1)
                next_state = C1; // stay, but sequence broken? Spec doesn't clarify, so restart
            else
                next_state = C0;
        end
        C2: begin
            if (x == 1'b1)
                next_state = D;
            else
                next_state = C0;
        end
        D: begin
            if (y == 1'b1) begin
                next_state = E; // permanent g=1
            end else if (y_counter == 2'd1) begin
                // This is after second cycle monitoring y (y_counter starts at 0, counts 1 next)
                // if y not 1, go to F
                next_state = F;
            end else begin
                next_state = D; // continue monitoring
            end
        end
        E: begin
            // stay until reset
            next_state = E;
        end
        F: begin
            // stay until reset
            next_state = F;
        end
        default: next_state = A;
    endcase
end

// Output logic
always @(*) begin
    // Default outputs
    f = 1'b0;
    g = 1'b0;

    case(state)
        B: f = 1'b1;
        D: g = 1'b1;
        E: g = 1'b1;
        F: g = 1'b0;
        default: begin
            f = 1'b0;
            g = 1'b0;
        end
    endcase
end

endmodule