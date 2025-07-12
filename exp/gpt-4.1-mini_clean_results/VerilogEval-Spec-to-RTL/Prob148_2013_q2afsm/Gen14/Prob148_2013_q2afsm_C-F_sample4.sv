module TopModule (
    input  wire        clk,
    input  wire        resetn,
    input  wire [2:0]  r,
    output reg  [2:0]  g
);

    // State encoding (2-bit binary)
    localparam [1:0]
        A = 2'b00,
        B = 2'b01, // grant device 0
        C = 2'b10, // grant device 1
        D = 2'b11; // grant device 2

    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic with priority encoding and grant hold
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

            B: next_state = r[0] ? B : A; // stay in B if r0 still asserted, else A
            C: next_state = r[1] ? C : A; // stay in C if r1 still asserted, else A
            D: next_state = r[2] ? D : A; // stay in D if r2 still asserted, else A

            default: next_state = A;
        endcase
    end

    // Output logic: grant signals derived directly from state bits
    // Device 0 grant when state == B (01)
    // Device 1 grant when state == C (10)
    // Device 2 grant when state == D (11)
    always @(*) begin
        // Default no grants
        g = 3'b000;

        case (state)
            B: g = 3'b001; // grant device 0
            C: g = 3'b010; // grant device 1
            D: g = 3'b100; // grant device 2
            default: g = 3'b000;
        endcase
    end

endmodule