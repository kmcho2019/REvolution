module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // States
    typedef enum reg {A, B} state_t;
    state_t state, next_state;

    reg [1:0] cycle_count;   // counts 0 to 3 cycles of w input
    reg [1:0] w_count;       // counts number of times w=1 in current 3-cycle window

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 0;
            w_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;

            if (state == A) begin
                // In A: z=0, counters reset
                z <= 0;
                cycle_count <= 0;
                w_count <= 0;
            end else if (state == B) begin
                if (cycle_count < 3) begin
                    cycle_count <= cycle_count + 1;
                    w_count <= w_count + w;
                    z <= 0;
                end else begin
                    // cycle_count==3, output z based on w_count, then reset counters
                    z <= (w_count == 2) ? 1'b1 : 1'b0;
                    cycle_count <= 1; // start counting the next 3 cycle window, first cycle counted now
                    w_count <= w;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: begin
                if (s == 1'b1)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B;
            end
            default: next_state = A;
        endcase
    end

endmodule