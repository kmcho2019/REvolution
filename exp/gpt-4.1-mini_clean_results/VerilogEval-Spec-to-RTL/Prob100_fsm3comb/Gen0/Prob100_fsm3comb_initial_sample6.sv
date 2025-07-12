module TopModule(
    input      in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

    always @(*) begin
        case (state)
            2'b00: begin // State A
                out = 1'b0;
                case (in)
                    1'b0: next_state = 2'b00; // A
                    1'b1: next_state = 2'b01; // B
                endcase
            end
            2'b01: begin // State B
                out = 1'b0;
                case (in)
                    1'b0: next_state = 2'b10; // C
                    1'b1: next_state = 2'b01; // B
                endcase
            end
            2'b10: begin // State C
                out = 1'b0;
                case (in)
                    1'b0: next_state = 2'b00; // A
                    1'b1: next_state = 2'b11; // D
                endcase
            end
            2'b11: begin // State D
                out = 1'b1;
                case (in)
                    1'b0: next_state = 2'b10; // C
                    1'b1: next_state = 2'b01; // B
                endcase
            end
            default: begin
                out = 1'b0;
                next_state = 2'b00;
            end
        endcase
    end

endmodule