module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding for clarity and simpler next-state logic
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Next-state logic
    always @(*) begin
        case (state)
            A: begin
                // Priority: r0 > r1 > r2; if none stay in A
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
                // Stay in B if r0=1, else back to A
                next_state = r[0] ? B : A;
            end
            C: begin
                // Stay in C if r1=1, else back to A
                next_state = r[1] ? C : A;
            end
            D: begin
                // Stay in D if r2=1, else back to A (added explicit hold behavior)
                next_state = r[2] ? D : A;
            end
            default: next_state = A;
        endcase
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic based on one-hot state encoding
    always @(*) begin
        // Initialize outputs to zero
        g = 3'b000;
        case (state)
            B: g = 3'b001; // grant device 0
            C: g = 3'b010; // grant device 1
            D: g = 3'b100; // grant device 2
            default: g = 3'b000;
        endcase
    end

endmodule