module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg       out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    always @(*) begin
        // Default assignments
        next_state = 2'b00;
        out = 1'b0;

        case (state)
            A: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            B: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = D;
            end
            D: begin
                out = 1'b1;
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            default: begin
                // In case of invalid state, default to A and output 0
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

endmodule