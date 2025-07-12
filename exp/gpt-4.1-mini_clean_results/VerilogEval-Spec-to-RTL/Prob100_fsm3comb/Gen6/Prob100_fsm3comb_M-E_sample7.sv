module TopModule (
    input  wire       in,
    input  wire [1:0] state,
    output reg  [1:0] next_state,
    output reg        out
);

    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    always @(*) begin
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
                // Default safe state
                out = 1'b0;
                next_state = A;
            end
        endcase
    end

endmodule