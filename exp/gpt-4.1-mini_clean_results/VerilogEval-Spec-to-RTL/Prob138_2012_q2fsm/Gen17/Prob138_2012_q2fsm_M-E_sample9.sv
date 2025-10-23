module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // One-hot state encoding using 6 bits (one per state)
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential logic: state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic using if-else priority chain
    always @(*) begin
        if (state == A) begin
            if (w)
                next_state = B;
            else
                next_state = A;
        end
        else if (state == B) begin
            if (w)
                next_state = C;
            else
                next_state = D;
        end
        else if (state == C) begin
            if (w)
                next_state = E;
            else
                next_state = D;
        end
        else if (state == D) begin
            if (w)
                next_state = F;
            else
                next_state = A;
        end
        else if (state == E) begin
            if (w)
                next_state = E;
            else
                next_state = D;
        end
        else if (state == F) begin
            if (w)
                next_state = C;
            else
                next_state = D;
        end
        else begin
            // Safety fallback to reset state
            next_state = A;
        end
    end

    // Output logic: z asserted only in states E and F using always_comb style
    always @(*) begin
        if ((state == E) || (state == F))
            z = 1'b1;
        else
            z = 1'b0;
    end

endmodule