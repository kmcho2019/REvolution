module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot encoding for states
    localparam A = 4'b0001,
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

    // Next-state logic with minimized priority logic expressions
    always @(*) begin
        case (1'b1)  // Using casez as priority encoder replacement
            state[A]: begin
                // Priority logic for next state in A:
                // if r[0] assert -> B
                // else if r[1] assert -> C
                // else if r[2] assert -> D
                // else stay A
                if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else next_state = A;
            end
            state[B]: next_state = r[0] ? B : A;
            state[C]: next_state = r[1] ? C : A;
            state[D]: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

    // Output logic with continuous assignment using one-hot states for zero delay
    assign g = {state[D], state[C], state[B]};

endmodule