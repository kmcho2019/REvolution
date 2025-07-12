module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // Define states: A for idle; B0, B1, B2 for counting cycles 0,1,2 respectively
    typedef enum logic [1:0] {
        A = 2'b00,
        B0 = 2'b01,
        B1 = 2'b10,
        B2 = 2'b11
    } state_t;

    state_t state, next_state;

    reg [1:0] w_count, next_w_count;  // Accumulate count of w=1 in 3 cycles

    reg z_next;

    always @(*) begin
        // Default assignments to hold values
        next_state = state;
        next_w_count = w_count;
        z_next = 1'b0;

        case (state)
            A: begin
                // In state A, wait for s=1 to move to B0
                if (s)
                    next_state = B0;
                else
                    next_state = A;
                next_w_count = 2'd0; // reset accumulator in idle
                z_next = 1'b0;
            end

            B0: begin
                // First cycle counting w
                next_w_count = w_count + w; // accumulate if w=1
                next_state = B1;
                z_next = 1'b0;
            end

            B1: begin
                // Second cycle counting w
                next_w_count = w_count + w;
                next_state = B2;
                z_next = 1'b0;
            end

            B2: begin
                // Third cycle counting w
                next_w_count = w_count + w;

                // After counting three cycles, output z depends on count
                // Check if total count == 2
                if ((w_count + w) == 2)
                    z_next = 1'b1;
                else
                    z_next = 1'b0;

                // Restart counting from B0 for next 3-cycle window
                next_state = B0;
                next_w_count = 2'd0; // Reset accumulator after output
            end

            default: begin
                next_state = A;
                next_w_count = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential block with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            z <= z_next;
        end
    end

endmodule