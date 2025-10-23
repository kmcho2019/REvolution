module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Binary state encoding (2 bits)
    parameter [1:0] A = 2'b00,  // No grant
                   B = 2'b01,  // g0 granted
                   C = 2'b10,  // g1 granted
                   D = 2'b11;  // g2 granted

    reg [1:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            A: begin
                if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else next_state = A;
            end
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

    // Sequential state flip-flops
    always @(posedge clk) begin
        if (!resetn) current_state <= A;
        else current_state <= next_state;
    end

    // Simplified output logic - only assert relevant grant
    assign g[0] = (current_state == B);
    assign g[1] = (current_state == C);
    assign g[2] = (current_state == D);

endmodule