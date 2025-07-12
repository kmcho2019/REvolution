module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (1'b1) // synthesis parallel_case
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

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic driven by one-hot state
    always @(*) begin
        g = 3'b000;
        if (state[B])
            g[0] = 1'b1;
        else if (state[C])
            g[1] = 1'b1;
        else if (state[D])
            g[2] = 1'b1;
    end

endmodule