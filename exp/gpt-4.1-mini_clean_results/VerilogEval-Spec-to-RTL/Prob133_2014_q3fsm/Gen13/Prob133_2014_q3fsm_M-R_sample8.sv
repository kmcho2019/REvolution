module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // One-hot state encoding
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state, next_state;
    reg [1:0] cycle_cnt, next_cycle_cnt; // counts from 0 to 2 for 3 cycles
    reg [1:0] w_count, next_w_count;     // counts number of w=1's in current window
    reg z_next;

    // State transition logic
    always @* begin
        next_state = state;
        case (state)
            A: next_state = s ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    // Cycle counter and w_count update logic
    always @* begin
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        z_next = 1'b0;

        if (state == A) begin
            next_cycle_cnt = 2'd0;
            next_w_count = 2'd0;
            z_next = 1'b0;
        end else if (state == B) begin
            if (cycle_cnt == 2) begin
                // End of 3-cycle window, check w count including current w input
                z_next = ((w_count + w) == 2);
                next_cycle_cnt = 2'd0;
                next_w_count = 2'd0;
            end else begin
                next_cycle_cnt = cycle_cnt + 2'd1;
                next_w_count = w_count + w;
                z_next = 1'b0;
            end
        end
    end

    // Sequential logic: state and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_count <= next_w_count;
            z <= z_next;
        end
    end

endmodule