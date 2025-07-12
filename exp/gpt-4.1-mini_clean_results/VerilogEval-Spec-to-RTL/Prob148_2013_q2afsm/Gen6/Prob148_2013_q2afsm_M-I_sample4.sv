module TopModule (
    input         clk,
    input         resetn,
    input  [2:0]  r,
    output [2:0]  g
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
        case (1'b1) // priority encoding using one-hot
            state[A]: begin
                if (r[0])
                    next_state = B;       // grant device 0
                else if (r[1])
                    next_state = C;       // grant device 1
                else if (r[2])
                    next_state = D;       // grant device 2
                else
                    next_state = A;       // no requests
            end

            state[B]: next_state = r[0] ? B : A;
            state[C]: next_state = r[1] ? C : A;
            state[D]: next_state = r[2] ? D : A;

            default: next_state = A;          // safe fallback
        endcase
    end

    // Output logic directly from one-hot states (Moore output)
    assign g = { state[D], state[C], state[B] }; // g[2] = D, g[1] = C, g[0] = B

endmodule