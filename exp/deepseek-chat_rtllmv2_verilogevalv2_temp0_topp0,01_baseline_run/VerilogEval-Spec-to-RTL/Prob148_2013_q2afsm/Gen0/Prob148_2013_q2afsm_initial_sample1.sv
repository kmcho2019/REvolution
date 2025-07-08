module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] current_state, next_state;

    // State transition logic
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
            D: next_state = r[2] ? D : A;  // Note: D behavior wasn't fully specified in problem
            default: next_state = A;
        endcase
    end

    // State storage
    always @(posedge clk) begin
        if (!resetn) current_state <= A;
        else current_state <= next_state;
    end

    // Output logic - g[0] in B, g[1] in C, g[2] in D
    assign g[0] = (current_state == B);
    assign g[1] = (current_state == C);
    assign g[2] = (current_state == D);

endmodule