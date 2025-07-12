module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic [0:0] {A=1'b0, B=1'b1} state_t;
    state_t state, next_state;

    reg [1:0] cycle_count;  // counts 0..2 cycles in B
    reg [1:0] w_count;      // counts how many times w=1 in current 3 cycles
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            if (state == A) begin
                // In A: reset counters and output
                cycle_count <= 2'd0;
                w_count <= 2'd0;
                z <= 1'b0;
            end else begin
                // state B
                if (cycle_count < 2) begin
                    cycle_count <= cycle_count + 1;
                    w_count <= w_count + w;
                    z <= 1'b0; // output only after counting 3 cycles
                end else begin
                    // This is the 3rd cycle (cycle_count == 2)
                    w_count <= 2'd0;
                    cycle_count <= 2'd0;
                    // Evaluate z in next cycle
                    z <= (w_count + w == 2) ? 1'b1 : 1'b0;
                end
            end
        end
    end

    always @(*) begin
        case (state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B; // stay in B forever once entered
            end
            default: next_state = A;
        endcase
    end

endmodule