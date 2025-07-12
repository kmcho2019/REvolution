module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding using 3 bits for clarity (5 states: 0 to 4)
    localparam [2:0]
        A     = 3'd0,   // Wait for s=1
        B1    = 3'd1,   // Sample w #1
        B2    = 3'd2,   // Sample w #2
        B3    = 3'd3,   // Sample w #3
        B_out = 3'd4;   // Output cycle (set z accordingly)

    reg [2:0] state, next_state;
    reg [1:0] w_count, next_w_count; // counts how many w=1 in 3 samples

    // Sequential logic: state and w_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            z <= (next_state == B_out) ? (w_count == 2) : 1'b0;
        end
    end

    // Combinational next-state and w_count logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_w_count = w_count;

        case (state)
            A: begin
                z = 1'b0;       // ensure output zero in A
                next_w_count = 2'd0;
                if (s)
                    next_state = B1;
                else
                    next_state = A;
            end

            B1: begin
                // Sample w #1
                next_w_count = w ? 2'd1 : 2'd0;
                next_state = B2;
            end

            B2: begin
                // Sample w #2
                next_w_count = w_count + (w ? 2'd1 : 2'd0);
                next_state = B3;
            end

            B3: begin
                // Sample w #3
                next_w_count = w_count + (w ? 2'd1 : 2'd0);
                next_state = B_out;
            end

            B_out: begin
                // Output cycle
                // z updated in sequential always block based on w_count == 2
                // Reset w_count for next window and continue sampling
                next_w_count = 2'd0;
                next_state = B1;
            end

            default: begin
                next_state = A;
                next_w_count = 2'd0;
            end
        endcase
    end

endmodule