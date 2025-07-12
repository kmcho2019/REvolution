module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

always @(*) begin
    case (state)
        4'b0001: begin  // State A
            next_state = in ? 4'b0010 : 4'b0001;  // Next state is B when in=1, A when in=0
            out = 0;
        end
        4'b0010: begin  // State B
            next_state = in ? 4'b0010 : 4'b0100;  // Next state is B when in=1, C when in=0
            out = 0;
        end
        4'b0100: begin  // State C
            next_state = in ? 4'b1000 : 4'b0001;  // Next state is D when in=1, A when in=0
            out = 0;
        end
        4'b1000: begin  // State D
            next_state = in ? 4'b0010 : 4'b0100;  // Next state is B when in=1, C when in=0
            out = 1;
        end
        default: begin
            next_state = 4'bxxxx;  // Handle undefined states
            out = 1'bx;  // Output is unknown for undefined states
        end
    endcase
end

endmodule