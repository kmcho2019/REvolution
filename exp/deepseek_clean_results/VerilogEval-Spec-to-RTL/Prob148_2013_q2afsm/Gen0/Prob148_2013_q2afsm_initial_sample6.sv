module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] current_state, next_state;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (!resetn)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // State transition logic
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
            B: begin
                if (r[0])
                    next_state = B;
                else
                    next_state = A;
            end
            C: begin
                if (r[1])
                    next_state = C;
                else
                    next_state = A;
            end
            D: begin
                next_state = A;  // From the description, D seems to immediately transition back to A
            end
            default: next_state = A;
        endcase
    end

    // Output logic
    assign g[0] = (current_state == B);
    assign g[1] = (current_state == C);
    assign g[2] = (current_state == D);

endmodule