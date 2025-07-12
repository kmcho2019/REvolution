module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding (better for timing/power)
    localparam [3:0] A = 4'b0001,
                     B = 4'b0010,
                     C = 4'b0100,
                     D = 4'b1000;

    reg [3:0] current_state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic with strict priority
    always @(*) begin
        next_state = A;  // Default to state A
        case (1'b1)  // Synthesis-friendly case statement for one-hot
            current_state[A]: begin
                if (r[0])       next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else           next_state = A;
            end
            current_state[B]: next_state = r[0] ? B : A;
            current_state[C]: next_state = r[1] ? C : A;
            current_state[D]: next_state = r[2] ? D : A;
        endcase
    end

    // Output assignments (combinational)
    assign g[0] = (current_state == B);
    assign g[1] = (current_state == C);
    assign g[2] = (current_state == D);

endmodule