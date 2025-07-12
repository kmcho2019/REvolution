module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum logic [2:0] {
        A  = 3'd0,
        B0 = 3'd1,
        B1 = 3'd2,
        B2 = 3'd3,
        Z  = 3'd4
    } state_t;

    state_t state, next_state;
    reg [1:0] w_count;  // counts number of w=1 in three cycles

    // Sequential logic: state and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Output z only valid in state Z cycle
            if (next_state == Z) begin
                // z set in next state logic, but to avoid glitch set here
                z <= (w_count == 2) ? 1'b1 : 1'b0;
            end else begin
                // clear z except in Z state
                z <= 1'b0;
            end

            // Count w only in B states
            if (state == B0 || state == B1 || state == B2) begin
                if (w)
                    w_count <= w_count + 1'b1;
            end else if (state == A) begin
                w_count <= 2'd0;
            end else if (state == Z) begin
                // reset count before new measurement
                w_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: begin
                if (s)
                    next_state = B0;
                else
                    next_state = A;
            end
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = Z;
            Z:  next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule