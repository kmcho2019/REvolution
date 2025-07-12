module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg       out
);

always @(*) begin
    // Default output for states A, B, C
    out = 1'b0;

    case (state)
        2'b00: begin // State A
            if (in == 1'b0)
                next_state = 2'b00; // A
            else
                next_state = 2'b01; // B
        end
        2'b01: begin // State B
            if (in == 1'b0)
                next_state = 2'b10; // C
            else
                next_state = 2'b01; // B
        end
        2'b10: begin // State C
            if (in == 1'b0)
                next_state = 2'b00; // A
            else
                next_state = 2'b11; // D
        end
        2'b11: begin // State D
            out = 1'b1;
            if (in == 1'b0)
                next_state = 2'b10; // C
            else
                next_state = 2'b01; // B
        end
        default: begin
            next_state = 2'b00;
        end
    endcase
end

endmodule