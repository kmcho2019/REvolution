module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: 2-bit states for clarity
    localparam A  = 2'b00; // Waiting for s=1
    localparam B0 = 2'b01; // 1st cycle of 3-cycle window
    localparam B1 = 2'b10; // 2nd cycle
    localparam B2 = 2'b11; // 3rd cycle, evaluate w counts

    reg [1:0] state, next_state;

    reg [1:0] w_count, next_w_count; // counts how many times w=1 in current 3-cycle window

    reg z_next; // next cycle output

    // Combinational next state and outputs
    always @(*) begin
        // Default assignments to prevent latches
        next_state = state;
        next_w_count = w_count;
        z_next = 1'b0;

        case(state)
            A: begin
                // In state A, monitor s; reset counters and output
                next_w_count = 2'b00;
                z_next = 1'b0;
                if (s)
                    next_state = B0; // start counting w in next state
                else
                    next_state = A;
            end

            B0: begin
                // first cycle: add w to count and move to next cycle
                next_w_count = w_count + w;
                next_state = B1;
                z_next = 1'b0; // output z only after 3rd cycle window + 1 cycle
            end

            B1: begin
                // second cycle: add w and move to next
                next_w_count = w_count + w;
                next_state = B2;
                z_next = 1'b0;
            end

            B2: begin
                // third cycle: add w, evaluate if exactly two ones were received in 3 cycles
                // output z in next cycle (which will be B0 again)
                next_state = B0;
                // w_count + w is total number of ones in 3 cycles
                z_next = ((w_count + w) == 2);
                next_w_count = 2'b00; // reset count for next 3-cycle window
            end

            default: begin
                // safety fallback to A
                next_state = A;
                next_w_count = 2'b00;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential logic: update state, w_count, and output z
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            z <= z_next;
        end
    end

endmodule