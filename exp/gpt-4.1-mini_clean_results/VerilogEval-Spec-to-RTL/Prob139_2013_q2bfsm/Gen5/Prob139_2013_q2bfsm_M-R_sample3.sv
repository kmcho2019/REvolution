module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

// State encoding
typedef enum logic [2:0] {
    A = 3'd0, // reset state, wait for resetn de-assertion
    B = 3'd1, // f=1 pulse for one cycle after reset release
    C = 3'd2, // sequence detection via shift register for x=1,0,1
    D = 3'd3, // g=1 asserted, monitor y input for up to 2 cycles
    E = 3'd4, // permanent success: g=1 forever until reset
    F = 3'd5  // permanent failure: g=0 forever until reset
} state_t;

state_t state, next_state;

// Shift register to detect x sequence 1,0,1 in three successive cycles
logic [2:0] x_shift;

// Counter for y monitoring in D state (counts 0 to 2)
logic [1:0] y_counter;
logic y_counter_reset, y_counter_enable;

always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_shift <= 3'b000;
        y_counter <= 2'd0;
    end else begin
        state <= next_state;

        // Update x_shift only in C state, else keep it zero
        if (next_state == C)
            x_shift <= {x_shift[1:0], x};
        else
            x_shift <= 3'b000;

        // y_counter management in D state
        if (y_counter_reset)
            y_counter <= 2'd0;
        else if (y_counter_enable)
            y_counter <= y_counter + 1'b1;
        else
            y_counter <= y_counter;
    end
end

// Next state logic
always_comb begin
    next_state = state;
    y_counter_reset = 1'b0;
    y_counter_enable = 1'b0;

    case(state)
        A: begin
            // Wait for resetn to go high, then move to B to pulse f
            if (resetn)
                next_state = B;
            else
                next_state = A;
        end
        B: begin
            // After one cycle with f=1, start sequence detection
            next_state = C;
        end
        C: begin
            // Wait in C while shifting x samples, detect pattern 3'b101
            // Note: x_shift updates on next clock, so check current x_shift
            if (x_shift == 3'b101)
                next_state = D;
            else
                next_state = C;
        end
        D: begin
            // On entry to D, reset y_counter
            if (state != D)
                y_counter_reset = 1'b1;
            else
                y_counter_reset = 1'b0;

            // Enable counter increment while in D (except just after reset)
            if (state == D && !y_counter_reset)
                y_counter_enable = 1'b1;

            // If y==1 anytime in D, go to permanent success E
            if (y == 1'b1)
                next_state = E;
            // Else if 2 cycles elapsed without y==1, move to F (permanent failure)
            else if (y_counter == 2)
                next_state = F;
            else
                next_state = D;
        end
        E: begin
            // Permanent success: remain here until reset
            next_state = E;
        end
        F: begin
            // Permanent failure: remain here until reset
            next_state = F;
        end
        default: next_state = A;
    endcase
end

// Outputs combinationally driven by current state (Moore outputs)
assign f = (state == B);
assign g = (state == D) || (state == E);

endmodule