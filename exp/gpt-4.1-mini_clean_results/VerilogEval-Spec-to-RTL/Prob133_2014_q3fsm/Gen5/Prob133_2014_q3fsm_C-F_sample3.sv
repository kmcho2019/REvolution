module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0,
               B = 1'b1;

    reg state, state_next;
    reg [1:0] cycle_count, cycle_count_next; // counts 0..2 for three cycles
    reg [1:0] w_count, w_count_next;
    reg z_next;

    wire [2:0] total_w = w_count + w; // combinational sum of current w_count + input w

    // Combinational next-state, counters, and output logic
    always @(*) begin
        // Default assignments: hold current values and clear output pulse
        state_next = state;
        cycle_count_next = cycle_count;
        w_count_next = w_count;
        z_next = 1'b0;

        case (state)
            A: begin
                // In reset state A, wait for s=1 to move to B and start counting
                if (s) begin
                    state_next = B;
                    cycle_count_next = 2'd0;
                    w_count_next = 2'd0;
                    z_next = 1'b0;
                end else begin
                    // stay in A, counters and output cleared
                    cycle_count_next = 2'd0;
                    w_count_next = 2'd0;
                    z_next = 1'b0;
                end
            end
            B: begin
                // In B, cycle_count counts cycles 0..2 of the 3-cycle window
                if (cycle_count < 2) begin
                    // For cycle 0 and 1, accumulate w counts and increment cycle_count
                    cycle_count_next = cycle_count + 1'b1;
                    w_count_next = w_count + w;
                    z_next = 1'b0; // no output yet
                end else begin
                    // On cycle_count == 2 (3rd cycle)
                    // total_w includes current w input; output z=1 if total_w == 2
                    cycle_count_next = 2'd0; // reset for next window
                    w_count_next = 2'd0;     // reset count for next window
                    z_next = (total_w == 2) ? 1'b1 : 1'b0;
                end
                state_next = B; // remain in B regardless
            end
        endcase
    end

    // Sequential block: synchronous reset and state update on clk posedge
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= state_next;
            cycle_count <= cycle_count_next;
            w_count <= w_count_next;
            z <= z_next;
        end
    end

endmodule