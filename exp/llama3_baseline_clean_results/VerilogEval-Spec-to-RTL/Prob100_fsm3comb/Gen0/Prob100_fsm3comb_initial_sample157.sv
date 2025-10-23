module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*)
begin
    case(state)
        2'b00: // State A
        begin
            if (~in)
                next_state = 2'b00; // A -> A for in = 0
            else
                next_state = 2'b01; // A -> B for in = 1
            out = 1'b0;
        end
        2'b01: // State B
        begin
            if (~in)
                next_state = 2'b10; // B -> C for in = 0
            else
                next_state = 2'b01; // B -> B for in = 1
            out = 1'b0;
        end
        2'b10: // State C
        begin
            if (~in)
                next_state = 2'b00; // C -> A for in = 0
            else
                next_state = 2'b11; // C -> D for in = 1
            out = 1'b0;
        end
        2'b11: // State D
        begin
            if (~in)
                next_state = 2'b10; // D -> C for in = 0
            else
                next_state = 2'b01; // D -> B for in = 1
            out = 1'b1;
        end
        default:
        begin
            next_state = 2'b00;
            out = 1'b0;
        end
    endcase
end

endmodule