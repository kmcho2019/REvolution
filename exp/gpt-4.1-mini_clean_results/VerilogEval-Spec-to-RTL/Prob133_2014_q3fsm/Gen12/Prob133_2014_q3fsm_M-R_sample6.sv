module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    reg [1:0] cycle_count, next_cycle_count;
    reg [1:0] w_accum, next_w_accum;
    reg z_next;

    // Combinational logic for next state and counters
    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_count = cycle_count;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case(state)
            A: begin
                // In state A, reset counters and output
                next_cycle_count = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;

                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // Accumulate w and count cycles
                next_cycle_count = cycle_count + 2'd1;
                next_w_accum = w_accum + w;
                next_state = B;
                z_next = 1'b0;

                if (next_cycle_count == 2'd3) begin
                    // After 3 cycles (0,1,2 counted; here when incremented from 2 to 3)
                    // output z in next cycle: 1 if exactly two w's high in last 3 cycles
                    next_state = B;  // Remain in B
                    // Cycle count and w_accum will be reset after outputting z
                end
            end

            default: begin
                next_state = A;
                next_cycle_count = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential logic for state, counters, and output z
    reg z_reg;
    reg [1:0] cycle_count_reg;
    reg [1:0] w_accum_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count_reg <= 2'd0;
            w_accum_reg <= 2'd0;
            z_reg <= 1'b0;
        end else begin
            state <= next_state;

            if (state == B) begin
                if (cycle_count_reg == 2'd2) begin
                    // On the 3rd cycle: output z based on accumulated w + current w
                    z_reg <= ((w_accum_reg + w) == 2);
                    cycle_count_reg <= 2'd0;
                    w_accum_reg <= 2'd0;
                end else begin
                    cycle_count_reg <= cycle_count_reg + 2'd1;
                    w_accum_reg <= w_accum_reg + w;
                    z_reg <= 1'b0;
                end
            end else begin
                // In state A reset counters and output
                cycle_count_reg <= 2'd0;
                w_accum_reg <= 2'd0;
                z_reg <= 1'b0;
            end
        end
    end

    // Output register assignment
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= z_reg;
    end

endmodule