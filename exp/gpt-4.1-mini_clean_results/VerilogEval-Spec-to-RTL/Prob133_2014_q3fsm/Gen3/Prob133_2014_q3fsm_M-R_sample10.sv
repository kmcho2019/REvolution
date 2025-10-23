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

    // Counters to track number of cycles (0..2) and w count (0..3)
    reg [1:0] cycle_count, next_cycle_count;
    reg [1:0] w_count, next_w_count;

    // Sequential state and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_count <= next_cycle_count;
            w_count <= next_w_count;
            z <= (state == B && cycle_count == 2) ? (w_count + w == 2) : 1'b0;
        end
    end

    // Combinational next state and counters logic
    always @(*) begin
        next_state = state;
        next_cycle_count = cycle_count;
        next_w_count = w_count;

        case(state)
            A: begin
                // Stay in A until s=1, then move to B
                if (s) begin
                    next_state = B;
                    next_cycle_count = 2'd0;
                    next_w_count = 2'd0;
                end
            end

            B: begin
                if (cycle_count < 2) begin
                    // Counting w and cycles for 3 cycles total
                    next_cycle_count = cycle_count + 1;
                    next_w_count = w_count + w;
                end else begin
                    // After 3rd cycle, reset counts for next batch
                    next_cycle_count = 2'd0;
                    next_w_count = 2'd0;
                end
            end
        endcase
    end

endmodule