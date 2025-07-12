module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: one-hot with named states for readability
    localparam [2:0]
        A = 3'b000, // Idle state, no grants
        B = 3'b001, // Grant device 0
        C = 3'b010, // Grant device 1
        D = 3'b100; // Grant device 2

    reg [2:0] state, next_state;

    // Sequential logic: state register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next-state logic based on current state and requests
    always @(*) begin
        case (state)
            A: begin // Idle state: prioritize requests r[0] > r[1] > r[2]
                if (r[0])
                    next_state = B;
                else if (r[1])
                    next_state = C;
                else if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end
            B: // Stay in grant if r[0] still asserted, else go to idle
                next_state = r[0] ? B : A;

            C: // Stay in grant if r[1] still asserted, else go to idle
                next_state = r[1] ? C : A;

            D: // Stay in grant if r[2] still asserted, else go to idle
                next_state = r[2] ? D : A;

            default:
                next_state = A; // Safe fallback
        endcase
    end

    // Output logic: grant signals correspond directly to one-hot state bits
    assign g = state;

endmodule