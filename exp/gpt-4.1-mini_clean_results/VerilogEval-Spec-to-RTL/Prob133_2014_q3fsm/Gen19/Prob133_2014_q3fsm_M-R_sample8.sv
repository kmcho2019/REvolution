module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // One-hot states for clarity
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    reg state, next_state;

    // Cycle counter: counts 0,1,2 for three cycles
    reg [1:0] cycle_count;

    // Accumulate count of w=1 samples during three-cycle window
    reg [2:0] w_ones_count;

    // Next state logic
    always @(*) begin
        case (state)
            STATE_A: next_state = s ? STATE_B : STATE_A;
            STATE_B: next_state = STATE_B;
            default: next_state = STATE_A;
        endcase
    end

    // Sequential logic: state update, counting, and output generation
    always @(posedge clk) begin
        if (reset) begin
            state        <= STATE_A;
            cycle_count  <= 2'd0;
            w_ones_count <= 3'd0;
            z            <= 1'b0;
        end else begin
            state <= next_state;

            if (state == STATE_A) begin
                // Reset counters and output in A state
                cycle_count  <= 2'd0;
                w_ones_count <= 3'd0;
                z            <= 1'b0;
            end else begin
                // In state B, accumulate and count cycles
                if (cycle_count < 2) begin
                    cycle_count  <= cycle_count + 1'b1;
                    w_ones_count <= w_ones_count + w;
                    z            <= 1'b0;
                end else begin
                    // On the 3rd cycle (cycle_count == 2), add current w sample
                    w_ones_count <= 3'd0;
                    cycle_count  <= 2'd0;
                    // Output z=1 if exactly two of the three w samples are 1
                    // w_ones_count holds sum of previous two w samples, add current w
                    z <= ((w_ones_count + w) == 3'd2) ? 1'b1 : 1'b0;
                end
            end
        end
    end

endmodule