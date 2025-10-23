module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Binary state encoding
    localparam A = 2'b00;
    localparam B = 2'b01;  // g0
    localparam C = 2'b10;  // g1
    localparam D = 2'b11;  // g2

    reg [1:0] state, next_state;

    // State transitions
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (state)
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

    // Output assignments
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);

endmodule