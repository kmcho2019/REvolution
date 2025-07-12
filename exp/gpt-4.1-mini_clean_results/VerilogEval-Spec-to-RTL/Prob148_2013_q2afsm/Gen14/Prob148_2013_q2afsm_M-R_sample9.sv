module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: 2-bit binary
    localparam [1:0]
        A = 2'b00,  // Idle, no grant
        B = 2'b01,  // Grant device 0
        C = 2'b10,  // Grant device 1
        D = 2'b11;  // Grant device 2

    reg [1:0] state, next_state;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic implementing priority and grant hold
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

            B:
                next_state = r[0] ? B : A;

            C:
                next_state = r[1] ? C : A;

            D:
                next_state = r[2] ? D : A;

            default:
                next_state = A; // safe default
        endcase
    end

    // Continuous assignment of grants based on current state
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule