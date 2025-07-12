module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    parameter A = 3'd0,
              B = 3'd1,
              C = 3'd2,
              D = 3'd3,
              E = 3'd4,
              F = 3'd5;

    reg [2:0] current_state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Combinational next state logic (blocking assignments)
    always @(*) begin
        case (current_state)
            A: begin
                if (w)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (w)
                    next_state = C;
                else
                    next_state = D;
            end
            C: begin
                if (w)
                    next_state = E;
                else
                    next_state = D;
            end
            D: begin
                if (w)
                    next_state = F;
                else
                    next_state = A;
            end
            E: begin
                if (w)
                    next_state = E;
                else
                    next_state = D;
            end
            F: begin
                if (w)
                    next_state = C;
                else
                    next_state = D;
            end
            default: next_state = A;
        endcase
    end

    // Output logic in a separate always block (Moore output)
    always @(*) begin
        case (current_state)
            E, F: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule