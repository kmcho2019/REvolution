module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        case (1'b1)  // synthesis parallel_case
            state[0]: next_state = in ? 4'b0010 : 4'b0001;  // State A
            state[1]: next_state = in ? 4'b0010 : 4'b0100;  // State B
            state[2]: next_state = in ? 4'b1000 : 4'b0001;  // State C
            state[3]: next_state = in ? 4'b0010 : 4'b0100;  // State D
            default:  next_state = 4'b0001;  // Default to State A
        endcase
    end

    assign out = state[3];

endmodule