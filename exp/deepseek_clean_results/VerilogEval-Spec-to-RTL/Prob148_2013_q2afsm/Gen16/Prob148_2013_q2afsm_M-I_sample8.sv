module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam [3:0] A = 4'b0001,
                     B = 4'b0010,
                     C = 4'b0100,
                     D = 4'b1000;

    reg [3:0] state, next_state;
    wire clk_gated;

    // Clock gating control
    assign clk_gated = clk & (|next_state | ~resetn);

    // State register with synchronous reset and clock gating
    always @(posedge clk_gated) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Combined priority evaluation and next state logic
    always @(*) begin
        case (1'b1)
            state[A]: begin
                if (r[0])
                    next_state = B;
                else if (r[1])
                    next_state = C;
                else if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end
            state[B]: next_state = r[0] ? B : A;
            state[C]: next_state = r[1] ? C : A;
            state[D]: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

    // Direct output assignments from state bits
    assign g[0] = state[B];
    assign g[1] = state[C];
    assign g[2] = state[D];

endmodule