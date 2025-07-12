module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding (4 bits)
    localparam A = 4'b0001; // idle
    localparam B = 4'b0010; // grant device 0
    localparam C = 4'b0100; // grant device 1
    localparam D = 4'b1000; // grant device 2

    reg [3:0] state, next_state;

    // Sequential: state flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational: next state logic
    always @(*) begin
        case (state)
            A: begin
                if (r[0])
                    next_state = B;    // grant device 0
                else if (r[1])
                    next_state = C;    // grant device 1
                else if (r[2])
                    next_state = D;    // grant device 2
                else
                    next_state = A;    // stay in idle
            end

            B: next_state = r[0] ? B : A;  // stay in B if r0, else idle
            C: next_state = r[1] ? C : A;  // stay in C if r1, else idle
            D: next_state = r[2] ? D : A;  // stay in D if r2, else idle

            default: next_state = A;        // safe fallback
        endcase
    end

    // Combinational: output logic from state (one-hot to grant)
    assign g[0] = state[1]; // B
    assign g[1] = state[2]; // C
    assign g[2] = state[3]; // D

endmodule