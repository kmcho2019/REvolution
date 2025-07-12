module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding (2 bits for 4 states)
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    reg [1:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic with integrated priority evaluation
    always @(*) begin
        case (state)
            A: begin
                if (r[0])          next_state = B;    // Highest priority
                else if (r[1])     next_state = C;    // Medium priority
                else if (r[2])     next_state = D;    // Lowest priority
                else               next_state = A;
            end
            B: next_state = r[0] ? B : A;  // Stay if request continues
            C: next_state = r[1] ? C : A;  // Stay if request continues
            D: next_state = r[2] ? D : A;  // Stay if request continues
            default: next_state = A;
        endcase
    end

    // Output assignments - one-hot encoding based on state
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);

endmodule