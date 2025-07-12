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
    A = 3'd0, // Reset state, wait for resetn deassertion
    B = 3'd1, // f=1 one cycle after reset release
    C0= 3'd2, // waiting for x=1 (start of sequence)
    C1= 3'd3, // expecting x=0
    C2= 3'd4, // expecting x=1
    D = 3'd5, // g=1 monitoring y for 2 cycles
    E = 3'd6, // g=1 permanent success
    F = 3'd7  // g=0 permanent fail
} state_t;

reg [2:0] state, next_state;

// Counter for monitoring y in state D (2 cycles max: count 0 and 1)
reg [1:0] y_counter;

// Sequential logic for state and y_counter
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        y_counter <= 2'd0;
    end else begin
        state <= next_state;
        if (state == D) begin
            y_counter <= y_counter + 2'd1;
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
            // Wait for reset release; stay in A while resetn=0
            // Once resetn=1, go to B on next clock edge
            if (resetn)
                next_state = B;
            else
                next_state = A;
        end
        B: begin
            // f=1 one cycle
            // move to C0 next clock
            next_state = C0;
        end
        C0: begin
            // Wait for x=1 to start sequence
            if (x == 1'b1)
                next_state = C1;
            else
                next_state = C0;
        end
        C1: begin
            // Expect x=0; if x=0, go to C2
            // if x=1, restart from C1 (since sequence start again)
            // else (x != 0 or 1), go to C0 (restart)
            if (x == 1'b0)
                next_state = C2;
            else if (x == 1'b1)
                next_state = C1; // treat as restart of sequence at x=1
            else
                next_state = C0;
        end
        C2: begin
            // Expect x=1 to complete sequence
            // if x=1, sequence matched, go to D
            // else if x=1, restart sequence at C1
            // else back to C0
            if (x == 1'b1)
                next_state = D;
            else if (x == 1'b1) // redundant condition but kept logically consistent
                next_state = C1;
            else
                next_state = C0;
        end
        D: begin
            // g=1 and monitor y for up to 2 cycles
            // if y==1 at any cycle, go to E (permanent success)
            // else if y_counter == 2 (two cycles passed) and no y==1, go to F
            if (y == 1'b1) begin
                next_state = E;
            end else if (y_counter == 2'd1) begin
                // After second cycle with no y=1, fail
                next_state = F;
            end else begin
                next_state = D; // keep monitoring
            end
        end
        E: begin
            // permanent g=1 success state
            next_state = E;
        end
        F: begin
            // permanent g=0 failure state
            next_state = F;
        end
        default: next_state = A;
    endcase
end

// Output logic synchronized to state register to avoid glitches
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        case (state)
            B: begin
                f <= 1'b1;
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

endmodule