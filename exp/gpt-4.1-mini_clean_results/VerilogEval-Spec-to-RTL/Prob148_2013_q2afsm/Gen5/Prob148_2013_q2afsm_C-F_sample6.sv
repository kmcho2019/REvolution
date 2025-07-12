module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding (binary)
    localparam [1:0]
        A = 2'b00, // idle
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

    // Next state logic combinational
    always @(*) begin
        case (state)
            A: begin
                if (r[0])
                    next_state = B;      // grant device 0
                else if (r[1])
                    next_state = C;      // grant device 1
                else if (r[2])
                    next_state = D;      // grant device 2
                else
                    next_state = A;
            end

            B: next_state = r[0] ? B : A;   // stay if request 0 active else idle
            C: next_state = r[1] ? C : A;   // stay if request 1 active else idle
            D: next_state = r[2] ? D : A;   // stay if request 2 active else idle

            default: next_state = A;         // safe fallback
        endcase
    end

    // Output logic combinational - grant only to current state device
    always @(*) begin
        case (state)
            B: g = 3'b001; // grant device 0
            C: g = 3'b010; // grant device 1
            D: g = 3'b100; // grant device 2
            default: g = 3'b000; // no grant in idle
        endcase
    end

endmodule