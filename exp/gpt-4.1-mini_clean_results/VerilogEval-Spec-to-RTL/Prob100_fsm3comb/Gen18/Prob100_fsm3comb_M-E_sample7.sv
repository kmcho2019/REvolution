module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg       out
);

    // State encoding for clarity
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    always @* begin
        case (state)
            A: begin
                out = 1'b0;
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                out = 1'b0;
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            C: begin
                out = 1'b0;
                if (in)
                    next_state = D;
                else
                    next_state = A;
            end
            D: begin
                out = 1'b1;
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            default: begin
                out = 1'b0;
                next_state = A; // safe default
            end
        endcase
    end

endmodule