module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam [3:0] A = 4'b0001,
                     B = 4'b0010,
                     C = 4'b0100,
                     D = 4'b1000;

    reg [3:0] current_state, next_state;

    // State register (sequential logic)
    always @(posedge clk) begin
        if (!resetn)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (current_state)
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
        endcase
    end

    // Output logic (combinational)
    assign g[0] = (current_state == B);
    assign g[1] = (current_state == C);
    assign g[2] = (current_state == D);

endmodule