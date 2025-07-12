module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // Define states with encoding
    localparam [1:0]
        A = 2'd0,  // Waiting for s=1
        B = 2'd1,  // Collecting w samples (3 cycles)
        C = 2'd2;  // Output z for one cycle

    reg [1:0] state, next_state;
    reg [1:0] cnt, next_cnt;      // Counts 0 to 2 for 3 cycles total
    reg [1:0] accum, next_accum;  // Counts how many w=1 have occurred (0 to 3)
    reg next_z;

    // Combinational next state and outputs logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_cnt = cnt;
        next_accum = accum;
        next_z = 1'b0;

        case(state)
            A: begin
                next_z = 1'b0;
                next_cnt = 2'd0;
                next_accum = 2'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // Accumulate w and increment count
                next_accum = accum + w;
                if (cnt == 2) begin
                    // After 3 cycles (cnt=0,1,2), move to output state
                    next_state = C;
                    next_cnt = 2'd0; // reset count for next window
                end else begin
                    // Continue sampling
                    next_state = B;
                    next_cnt = cnt + 2'd1;
                end
                next_z = 1'b0;
            end

            C: begin
                // Output z=1 if exactly two w=1 counted
                next_z = (accum == 2);
                next_state = B;   // Start new window after output
                next_cnt = 2'd0;
                next_accum = 2'd0;
            end

            default: begin
                next_state = A;
                next_cnt = 2'd0;
                next_accum = 2'd0;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic: update state, counter, accumulator, and output z
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cnt <= 2'd0;
            accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            accum <= next_accum;
            z <= next_z;
        end
    end

endmodule