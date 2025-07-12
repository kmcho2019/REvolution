module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (one-hot)
    localparam [2:0]
        A = 3'b000, // idle
        B = 3'b001, // grant device 0
        C = 3'b010, // grant device 1
        D = 3'b100; // grant device 2

    reg [2:0] state, next_state;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic with priority: r[0] > r[1] > r[2]
    always @(*) begin
        case (state)
            A: begin
                if (r[0])
                    next_state = B;
                else if (r[1])
                    next_state = C;
                else if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
            default: next_state = A; // Safe fallback
        endcase
    end

    // Output g corresponds directly to the grant states (one-hot)
    assign g = state;

endmodule