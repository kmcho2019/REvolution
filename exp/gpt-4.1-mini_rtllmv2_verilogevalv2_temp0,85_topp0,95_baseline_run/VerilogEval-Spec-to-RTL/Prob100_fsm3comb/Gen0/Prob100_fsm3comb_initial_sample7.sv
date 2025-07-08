module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg   out
);

    always @(*) begin
        case (state)
            2'b00: begin // A
                out = 0;
                next_state = in ? 2'b01 : 2'b00; // A->B if in=1 else A->A
            end
            2'b01: begin // B
                out = 0;
                next_state = in ? 2'b01 : 2'b10; // B->B if in=1 else B->C
            end
            2'b10: begin // C
                out = 0;
                next_state = in ? 2'b11 : 2'b00; // C->D if in=1 else C->A
            end
            2'b11: begin // D
                out = 1;
                next_state = in ? 2'b01 : 2'b10; // D->B if in=1 else D->C
            end
            default: begin
                out = 0;
                next_state = 2'b00; // default to A
            end
        endcase
    end

endmodule