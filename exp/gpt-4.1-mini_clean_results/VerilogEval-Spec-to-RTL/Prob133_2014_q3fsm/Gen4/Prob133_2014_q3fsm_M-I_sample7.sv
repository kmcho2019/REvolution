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
    reg [1:0] cycle_count; // counts 0,1,2 for 3 cycles
    reg [1:0] w_count;     // counts how many times w=1 in the 3 cycles

    reg state_next;
    reg [1:0] cycle_count_next;
    reg [1:0] w_count_next;
    reg z_next;

    // Compute next cycle_count with modulo-3 counting without addition
    always @(*) begin
        // Default assignments
        state_next = state;
        cycle_count_next = cycle_count;
        w_count_next = w_count;
        z_next = 1'b0;

        case(state)
            A: begin
                cycle_count_next = 2'd0;
                w_count_next = 2'd0;
                z_next = 1'b0;
                if (s)
                    state_next = B;
                else
                    state_next = A;
            end
            B: begin
                if (cycle_count == 2) begin
                    // At end of 3-cycle window, output z if exactly two w's counted
                    if (w_count == 2)
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;
                    cycle_count_next = 2'd0;
                    w_count_next = 2'd0;
                end else begin
                    // Increment cycle count modulo 3 (0->1,1->2)
                    if (cycle_count == 0)
                        cycle_count_next = 1;
                    else // cycle_count ==1
                        cycle_count_next = 2;
                    // Update w_count by adding current w
                    w_count_next = w_count + w;
                    z_next = 1'b0;
                end
                state_next = B;
            end
        endcase
    end

    // Sequential block updates state, counters, and output
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