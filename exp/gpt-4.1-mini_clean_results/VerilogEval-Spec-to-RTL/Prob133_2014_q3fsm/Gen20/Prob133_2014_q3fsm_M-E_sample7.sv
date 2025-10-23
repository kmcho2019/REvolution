module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding using 2 bits
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;

    reg [1:0] state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt; // counts 0..2 for three cycles
    reg [1:0] w_count, next_w_count;     // counts w=1 occurrences (max 3)

    reg z_next;

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default assignments
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        z_next = 1'b0;

        case(state)
            A: begin
                z_next = 1'b0;
                next_cycle_cnt = 2'b00;
                next_w_count = 2'b00;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // Accumulate w and increment cycle counter
                next_w_count = w_count + w;
                next_cycle_cnt = cycle_cnt + 2'b01;
                z_next = 1'b0;

                if (cycle_cnt == 2) begin
                    // After 3 cycles, move to state C to output z
                    next_state = C;
                    next_cycle_cnt = 2'b00;
                    next_w_count = w_count + w;  // include current cycle w in count
                end else begin
                    next_state = B;
                end
            end

            C: begin
                // Output z = 1 if exactly two w's were 1 in previous 3 cycles, else 0
                z_next = (w_count == 2);
                next_state = B;   // start next 3-cycle window
                next_cycle_cnt = 2'b00;
                next_w_count = 2'b00;
            end

            default: begin
                next_state = A;
                next_cycle_cnt = 2'b00;
                next_w_count = 2'b00;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_count <= next_w_count;
            z <= z_next;
        end
    end

endmodule