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

    reg state;
    reg [1:0] cycle_count;
    reg [1:0] w_count;

    reg [1:0] w_count_next;
    reg [1:0] cycle_count_next;
    reg state_next;
    reg z_next;

    wire [2:0] total_w = w_count + w; // combinational sum

    // Combinational next-state and next-counter logic
    always @(*) begin
        state_next = state;
        cycle_count_next = cycle_count;
        w_count_next = w_count;
        z_next = 1'b0; // default no output pulse

        case(state)
            A: begin
                if (s)
                    state_next = B;
                else
                    state_next = A;

                // In state A, counters reset and no output
                cycle_count_next = 2'd0;
                w_count_next = 2'd0;
            end
            B: begin
                if (cycle_count < 2) begin
                    // Counting cycles 0 and 1: increment counters
                    cycle_count_next = cycle_count + 1'b1;
                    w_count_next = w_count + w;
                    z_next = 1'b0; // no output while counting
                end else begin
                    // On the 3rd cycle (count=2), output z if total w_count == 2
                    cycle_count_next = 2'd0;
                    w_count_next = 2'd0;

                    if (total_w == 2)
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;
                end
                state_next = B; // remain in B
            end
        endcase
    end

    // Sequential logic for state, counters, and output
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