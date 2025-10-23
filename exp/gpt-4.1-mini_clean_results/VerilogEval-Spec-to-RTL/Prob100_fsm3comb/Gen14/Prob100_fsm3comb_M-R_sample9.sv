module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg       out
);

    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    always @(*) begin
        // Default assignments to avoid latches
        next_state = A;
        out = 1'b0;
        case (state)
            A: begin
                out = 1'b0;
                next_state = (in) ? B : A;
            end
            B: begin
                out = 1'b0;
                next_state = (in) ? B : C;
            end
            C: begin
                out = 1'b0;
                next_state = (in) ? D : A;
            end
            D: begin
                out = 1'b1;
                next_state = (in) ? B : C;
            end
            default: begin
                out = 1'b0;
                next_state = A;
            end
        endcase
    end

endmodule