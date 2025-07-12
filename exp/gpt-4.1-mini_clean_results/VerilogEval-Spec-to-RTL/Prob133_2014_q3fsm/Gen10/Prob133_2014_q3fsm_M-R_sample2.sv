module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam [0:0]
        A = 1'b0,
        B = 1'b1;

    reg state, next_state;

    // cycle_counter: 0,1,2 counts the three cycles in state B
    reg [1:0] cycle_counter, next_cycle_counter;

    // w_count accumulates how many times w=1 in the 3 cycles
    reg [1:0] w_count, next_w_count;

    // Output register next value
    reg next_z;

    // Next state, counters, and output combinational logic
    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_cycle_counter = cycle_counter;
        next_w_count = w_count;
        next_z = 1'b0;

        case (state)
            A: begin
                next_z = 1'b0;
                next_cycle_counter = 2'd0;
                next_w_count = 2'd0;
                if (s)
                    next_state = B;
            end
            B: begin
                // Advance cycle counter from 0 to 2
                if (cycle_counter == 2'd2) begin
                    // After third cycle, evaluate output z
                    // total count includes current w
                    // so add w to w_count to get total
                    // Output z = 1 if total count == 2
                    if ((w_count + w) == 2)
                        next_z = 1'b1;
                    else
                        next_z = 1'b0;

                    // Restart counting next group
                    next_cycle_counter = 2'd0;
                    next_w_count = 2'd0;
                end else begin
                    // Middle cycles: increment cycle counter and w_count
                    next_cycle_counter = cycle_counter + 1'b1;
                    next_w_count = w_count + w;
                    next_z = 1'b0;
                end
            end
        endcase
    end

    // Sequential logic: state, counters, and output register update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_counter <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_counter <= next_cycle_counter;
            w_count <= next_w_count;
            z <= next_z;
        end
    end

endmodule