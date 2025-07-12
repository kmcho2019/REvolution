module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (4-bit one-hot):
    // A (idle) = 4'b0001
    // B (grant device 0) = 4'b0010
    // C (grant device 1) = 4'b0100
    // D (grant device 2) = 4'b1000
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Sequential logic: state register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;  // reset to idle state A
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if      (r[0]) next_state = B; // grant device 0
                else if (r[1]) next_state = C; // grant device 1
                else if (r[2]) next_state = D; // grant device 2
                else           next_state = A; // remain idle
            end

            B: begin
                if (r[0])
                    next_state = B; // stay granted device 0
                else
                    next_state = A; // return to idle
            end

            C: begin
                if (r[1])
                    next_state = C; // stay granted device 1
                else
                    next_state = A; // return to idle
            end

            D: begin
                if (r[2])
                    next_state = D; // stay granted device 2
                else
                    next_state = A; // return to idle
            end

            default: next_state = A; // recover to idle on illegal states
        endcase
    end

    // Output grant signals assigned from respective grant states
    // grant to device 0 from B (bit 1)
    // grant to device 1 from C (bit 2)
    // grant to device 2 from D (bit 3)
    assign g[0] = state[1];
    assign g[1] = state[2];
    assign g[2] = state[3];

endmodule