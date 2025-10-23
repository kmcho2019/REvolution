module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    case (state)
        2'b00: begin // State A
            out = 1'b0;
            if (in) next_state = 2'b01; // A -> B
            else    next_state = 2'b00; // A -> A
        end
        2'b01: begin // State B
            out = 1'b0;
            if (in) next_state = 2'b01; // B -> B
            else    next_state = 2'b10; // B -> C
        end
        2'b10: begin // State C
            out = 1'b0;
            if (in) next_state = 2'b11; // C -> D
            else    next_state = 2'b00; // C -> A
        end
        2'b11: begin // State D
            out = 1'b1;
            if (in) next_state = 2'b01; // D -> B
            else    next_state = 2'b10; // D -> C
        end
        default: begin // Handle unexpected states
            out = 1'b0;
            next_state = 2'b00; // Reset to state A
        end
    endcase
end

endmodule