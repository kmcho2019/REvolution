module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output       g0,
    output       g1,
    output       g2
);

    // One-hot state encoding
    localparam [3:0]
        A = 4'b0001, // Idle
        B = 4'b0010, // Grant device 0
        C = 4'b0100, // Grant device 1
        D = 4'b1000; // Grant device 2

    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state combinational logic using one-hot states
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
            default:  next_state = A;
        endcase
    end

    // Outputs as continuous assignments based on one-hot state bits
    assign g0 = state[B];
    assign g1 = state[C];
    assign g2 = state[D];

endmodule