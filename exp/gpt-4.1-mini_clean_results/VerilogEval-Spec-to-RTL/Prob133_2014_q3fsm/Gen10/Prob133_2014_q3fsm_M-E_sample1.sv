module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        A  = 2'd0, // Waiting for s=1
        B0 = 2'd1, // 1st w cycle
        B1 = 2'd2, // 2nd w cycle
        B2 = 2'd3  // 3rd w cycle
    } state_t;

    state_t state, next_state;

    reg [1:0] count_w, next_count_w; // Counts number of w=1 in current window (0 to 3)
    reg next_z;

    always @(*) begin
        // Defaults
        next_state = state;
        next_count_w = count_w;
        next_z = 1'b0;

        case (state)
            A: begin
                // Reset count and output
                next_count_w = 2'd0;
                next_z = 1'b0;
                if (s)
                    next_state = B0;
                else
                    next_state = A;
            end

            B0: begin
                // Record w for 1st cycle
                next_count_w = w ? 2'd1 : 2'd0;
                next_z = 1'b0;
                next_state = B1;
            end

            B1: begin
                // Accumulate w for 2nd cycle
                next_count_w = count_w + (w ? 2'd1 : 2'd0);
                next_z = 1'b0;
                next_state = B2;
            end

            B2: begin
                // Accumulate w for 3rd cycle
                next_count_w = count_w + (w ? 2'd1 : 2'd0);
                // In next cycle after B2, output z = 1 if exactly two w=1's, else 0
                // So here set z for the *next* cycle, clear count for next window
                next_z = 1'b0;
                next_state = B0;
            end

            default: begin
                next_state = A;
                next_count_w = 2'd0;
                next_z = 1'b0;
            end
        endcase
    end

    // Output z logic: we assert z exactly one cycle after completing B2,
    // so track a delayed flag to generate z output.

    reg z_delayed_flag, next_z_delayed_flag;

    always @(*) begin
        next_z_delayed_flag = 1'b0;
        if (state == B2) begin
            // After B2, decide if z=1 for next cycle
            if (count_w + (w ? 2'd1 : 2'd0) == 2)
                next_z_delayed_flag = 1'b1;
        end
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count_w <= 2'd0;
            z <= 1'b0;
            z_delayed_flag <= 1'b0;
        end else begin
            state <= next_state;
            count_w <= next_count_w;
            z_delayed_flag <= next_z_delayed_flag;
            z <= z_delayed_flag;
        end
    end

endmodule