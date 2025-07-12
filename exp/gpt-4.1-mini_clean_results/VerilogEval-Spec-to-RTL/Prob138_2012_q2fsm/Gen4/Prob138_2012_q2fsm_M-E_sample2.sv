module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // One-hot state encoding: each state is a bit in a 6-bit vector
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic using combinational logic for one-hot encoding
    always @(*) begin
        // Default next_state all zero (invalid), then set exactly one bit
        next_state = 6'b000000;

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
            // If invalid state, reset to A
            next_state = A;
        end
    end

    // Output logic: z = 1 if in E or F, else 0
    always @(*) begin
        if (state == E || state == F)
            z = 1'b1;
        else
            z = 1'b0;
    end

endmodule