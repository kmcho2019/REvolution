module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state, next_state;

    // State register (sequential logic)
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            A: begin
                if (w == 1'b1)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (w == 1'b1)
                    next_state = C;
                else
                    next_state = D;
            end
            C: begin
                if (w == 1'b1)
                    next_state = E;
                else
                    next_state = D;
            end
            D: begin
                if (w == 1'b1)
                    next_state = F;
                else
                    next_state = A;
            end
            E: begin
                if (w == 1'b1)
                    next_state = E;
                else
                    next_state = D;
            end
            F: begin
                if (w == 1'b1)
                    next_state = C;
                else
                    next_state = D;
            end
            default: next_state = A; // default to A on invalid state
        endcase
    end

    // Output logic (Moore): z=1 in states E and F, else 0
    assign z = (state == E) || (state == F);

endmodule