module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    localparam A = 3'd0;
    localparam B = 3'd1;
    localparam C = 3'd2;
    localparam D = 3'd3;
    localparam E = 3'd4;
    localparam F = 3'd5;

    reg [2:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (w == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            end
            C: begin
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            end
            D: begin
                if (w == 1'b0)
                    next_state = F;
                else
                    next_state = A;
            end
            E: begin
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            end
            F: begin
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            end
            default: next_state = A;
        endcase
    end

    // Output logic: z=1 in states E and F, else 0
    always @(*) begin
        case (state)
            E, F: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule