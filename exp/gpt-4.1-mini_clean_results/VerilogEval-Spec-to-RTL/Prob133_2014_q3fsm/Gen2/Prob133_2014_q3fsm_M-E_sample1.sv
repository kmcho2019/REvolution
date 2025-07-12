module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: 3 bits enough for 5 states
    typedef enum reg [2:0] {
        A  = 3'd0, // Wait for s=1
        B0 = 3'd1, // Sample 1st w
        B1 = 3'd2, // Sample 2nd w
        B2 = 3'd3, // Sample 3rd w
        Bz = 3'd4  // Output cycle
    } state_t;

    state_t state, next_state;

    reg [1:0] count_w; // Count of w=1 in current 3-cycle window (0..3)

    // Next state logic and outputs
    always @(*) begin
        // Default assignments
        next_state = state;
        z = 1'b0; // default output is zero except in Bz state

        case(state)
            A: begin
                z = 1'b0;
                if (s == 1'b1)
                    next_state = B0;
                else
                    next_state = A;
            end

            B0: begin
                // sample first w
                next_state = B1;
            end

            B1: begin
                // sample second w
                next_state = B2;
            end

            B2: begin
                // sample third w
                next_state = Bz;
            end

            Bz: begin
                // output cycle: z = 1 if count_w == 2
                z = (count_w == 2);
                next_state = B0;
            end

            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count_w <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    count_w <= 2'd0; // reset count on waiting state
                    z <= 1'b0;
                end

                B0: begin
                    // sample first w
                    count_w <= (w == 1'b1) ? 2'd1 : 2'd0;
                    z <= 1'b0;
                end

                B1: begin
                    // sample second w
                    count_w <= count_w + (w == 1'b1 ? 1'b1 : 1'b0);
                    z <= 1'b0;
                end

                B2: begin
                    // sample third w
                    count_w <= count_w + (w == 1'b1 ? 1'b1 : 1'b0);
                    z <= 1'b0;
                end

                Bz: begin
                    // output cycle handled by combinational logic
                    // z already assigned in combinational block,
                    // so keep it stable here or update from combinational block.
                    z <= (count_w == 2);
                end

                default: begin
                    count_w <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule