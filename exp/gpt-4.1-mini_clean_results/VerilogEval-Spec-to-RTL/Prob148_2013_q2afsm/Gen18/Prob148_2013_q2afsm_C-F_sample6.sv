module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding (binary)
    localparam [1:0]
        A = 2'b00, // Idle: no grant
        B = 2'b01, // Grant device 0
        C = 2'b10, // Grant device 1
        D = 2'b11; // Grant device 2

    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic with priority encoding and hold grants
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

    // Output logic: decode grant from state
    always @(*) begin
        case (state)
            B: g = 3'b001; // grant device 0
            C: g = 3'b010; // grant device 1
            D: g = 3'b100; // grant device 2
            default: g = 3'b000; // no grant
        endcase
    end

endmodule