module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic [0:0] {A=1'b0, B=1'b1} state_t;
    state_t state, next_state;

    reg [1:0] cycle_count;  // counts 0..2 cycles in state B
    reg [1:0] w_count;      // counts how many times w=1 in current 3 cycles

    // Sequential logic for state, counters, and output
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            if (state == A) begin
                // In state A, reset counters and output
                cycle_count <= 2'd0;
                w_count <= 2'd0;
                z <= 1'b0;
            end else begin
                // State B: count cycles and w occurrences
                if (cycle_count < 2) begin
                    cycle_count <= cycle_count + 1'b1;
                    w_count <= w_count + w;   // add current w to count
                    z <= 1'b0;               // no output during counting
                end else begin
                    // On 3rd cycle (cycle_count == 2)
                    // Compute total w count including current w
                    // Output z=1 if total w count == 2, else 0
                    // Reset counters for next cycle set

                    // total_w_count = w_count + w
                    if ((w_count + w) == 2)
                        z <= 1'b1;
                    else
                        z <= 1'b0;

                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                end
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            A: next_state = (s == 1'b1) ? B : A;
            B: next_state = B;  // Remain in B indefinitely once entered
            default: next_state = A;
        endcase
    end

endmodule