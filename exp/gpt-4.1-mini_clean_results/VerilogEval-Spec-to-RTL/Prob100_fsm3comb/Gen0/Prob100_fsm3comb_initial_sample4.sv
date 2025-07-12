module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg       out
);

    always @(*) begin
        case(state)
            2'b00: begin // A
                out = 0;
                if (in == 0)
                    next_state = 2'b00; // A
                else
                    next_state = 2'b01; // B
            end
            2'b01: begin // B
                out = 0;
                if (in == 0)
                    next_state = 2'b10; // C
                else
                    next_state = 2'b01; // B
            end
            2'b10: begin // C
                out = 0;
                if (in == 0)
                    next_state = 2'b00; // A
                else
                    next_state = 2'b11; // D
            end
            2'b11: begin // D
                out = 1;
                if (in == 0)
                    next_state = 2'b10; // C
                else
                    next_state = 2'b01; // B
            end
            default: begin
                out = 0;
                next_state = 2'b00;
            end
        endcase
    end

endmodule