module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam A = 4'b0001; // idle
    localparam B = 4'b0010; // grant device 0
    localparam C = 4'b0100; // grant device 1
    localparam D = 4'b1000; // grant device 2

    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic with priority and grant sustain
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
            default: next_state = A;
        endcase
    end

    // Output logic: g[i] asserted if state grants device i
    assign g = {state[3], state[2], state[1]};

endmodule