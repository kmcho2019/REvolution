module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

always @(*) begin
    case (1'b1)
        state[0]: begin // State A
            next_state = in ? 4'b0010 : 4'b0001; // A -> B when in=1, A -> A when in=0
            out = 1'b0;
        end
        state[1]: begin // State B
            next_state = in ? 4'b0010 : 4'b0100; // B -> B when in=1, B -> C when in=0
            out = 1'b0;
        end
        state[2]: begin // State C
            next_state = in ? 4'b1000 : 4'b0001; // C -> D when in=1, C -> A when in=0
            out = 1'b0;
        end
        state[3]: begin // State D
            next_state = in ? 4'b0010 : 4'b0100; // D -> B when in=1, D -> C when in=0
            out = 1'b1;
        end
        default: begin
            next_state = 4'b0000; // default next state
            out = 1'b0;
        end
    endcase
end

endmodule