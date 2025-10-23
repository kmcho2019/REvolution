module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // One-hot state encoding
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential block: state register with synchronous reset; update output z here
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Output z is 1 only in states E or F
            z <= (next_state == E) || (next_state == F);
        end
    end

    // Combinational block: next state logic using if-else for readability
    always @(*) begin
        // Default next state to current to avoid latches
        next_state = state;

        if (state == A) begin
            if (w)
                next_state = B;
            else
                next_state = A;
        end else if (state == B) begin
            if (w)
                next_state = C;
            else
                next_state = D;
        end else if (state == C) begin
            if (w)
                next_state = E;
            else
                next_state = D;
        end else if (state == D) begin
            if (w)
                next_state = F;
            else
                next_state = A;
        end else if (state == E) begin
            if (w)
                next_state = E;
            else
                next_state = D;
        end else if (state == F) begin
            if (w)
                next_state = C;
            else
                next_state = D;
        end else begin
            // In case of invalid state, reset to A
            next_state = A;
        end
    end

endmodule