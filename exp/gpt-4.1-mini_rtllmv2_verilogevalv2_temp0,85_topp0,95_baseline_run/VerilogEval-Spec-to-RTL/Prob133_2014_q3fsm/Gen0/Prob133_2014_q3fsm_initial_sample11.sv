module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10
    } state_t;

    state_t state, next_state;

    reg [1:0] w_count;     // count of w=1 in current 3-cycle window (max 3)
    reg [1:0] cycle_count; // counts cycles within state B (0 to 2)

    // State and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 0;
            cycle_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;

            if (state == A) begin
                w_count <= 0;
                cycle_count <= 0;
                z <= 0;
            end else if (state == B) begin
                // count w=1
                if (w)
                    w_count <= w_count + 1;
                else
                    w_count <= w_count;

                cycle_count <= cycle_count + 1;
                z <= 0;
            end else if (state == C) begin
                // output z based on w_count
                z <= (w_count == 2) ? 1'b1 : 1'b0;
                // reset counters for next window
                w_count <= 0;
                cycle_count <= 0;
            end else begin
                z <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (cycle_count == 2)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                next_state = B;
            end
            default: next_state = A;
        endcase
    end

endmodule