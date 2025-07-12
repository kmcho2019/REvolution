module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // One-hot encoding for states (4 bits)
    localparam A = 4'b0001, // idle state
               B = 4'b0010, // grant device 0
               C = 4'b0100, // grant device 1
               D = 4'b1000; // grant device 2

    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case(state)
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
            B: next_state = (r[0]) ? B : A;
            C: next_state = (r[1]) ? C : A;
            D: next_state = (r[2]) ? D : A;
            default: next_state = A;
        endcase
    end

    // Output logic derived directly from state one-hot bits:
    // g[0] active when in B, g[1] active when in C, g[2] active when in D
    assign g = {state[3], state[2], state[1]};

endmodule