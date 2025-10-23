module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                // Priority: r0 > r1 > r2
                if (r[0])
                    next_state = B;
                else if (r[1])
                    next_state = C;
                else if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end

            B: begin
                // Stay in B if r0 asserted else back to A
                next_state = r[0] ? B : A;
            end

            C: begin
                // Stay in C if r1 asserted else back to A
                next_state = r[1] ? C : A;
            end

            D: begin
                // Stay in D if r2 asserted else back to A
                next_state = r[2] ? D : A;
            end

            default: next_state = A;
        endcase
    end

    // Grant outputs directly mapped from state bits
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);

endmodule