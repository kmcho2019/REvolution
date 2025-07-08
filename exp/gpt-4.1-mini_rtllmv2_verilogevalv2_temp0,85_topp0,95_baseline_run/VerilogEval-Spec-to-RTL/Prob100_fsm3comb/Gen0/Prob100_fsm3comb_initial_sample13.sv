module TopModule (
    input  wire       in,
    input  wire [1:0] state,
    output reg  [1:0] next_state,
    output reg        out
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    always @(*) begin
        case(state)
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
                out = 1'b0;
                next_state = A;
            end
        endcase
    end

endmodule