module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        case (1'b1)  // synthesis parallel_case
            state[0]: begin  // State A
                next_state = in ? 4'b0010 : 4'b0001;
            end
            state[1]: begin  // State B
                next_state = in ? 4'b0010 : 4'b0100;
            end
            state[2]: begin  // State C
                next_state = in ? 4'b1000 : 4'b0001;
            end
            state[3]: begin  // State D
                next_state = in ? 4'b0010 : 4'b0100;
            end
            default: next_state = 4'b0001;  // Default to state A
        endcase
    end

    assign out = state[3];  // Output is state D

endmodule