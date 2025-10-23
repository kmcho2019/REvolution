module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    case (state)
        2'b00: begin // State A
            next_state = in ? 2'b01 : 2'b00; // A->B if in=1, else stay A
            out = 1'b0;
        end
        2'b01: begin // State B
            next_state = in ? 2'b01 : 2'b10; // B->C if in=0, else stay B
            out = 1'b0;
        end
        2'b10: begin // State C
            next_state = in ? 2'b11 : 2'b00; // C->D if in=1, else C->A
            out = 1'b0;
        end
        2'b11: begin // State D
            next_state = in ? 2'b01 : 2'b10; // D->B if in=1, else D->C
            out = 1'b1;
        end
        default: begin // Default case (shouldn't occur with 2-bit state)
            next_state = 2'b00;
            out = 1'b0;
        end
    endcase
end

endmodule