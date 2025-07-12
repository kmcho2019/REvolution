module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg [2:0] next_state;
    reg Y1_reg;

    always @(*) begin
        case (y)
            3'b000: begin // State A
                if (~w) next_state = 3'b001; // Transition to B
                else next_state = 3'b000; // Stay in A
            end
            3'b001: begin // State B
                if (~w) next_state = 3'b010; // Transition to C
                else next_state = 3'b011; // Transition to D
            end
            3'b010: begin // State C
                if (~w) next_state = 3'b100; // Transition to E
                else next_state = 3'b011; // Transition to D
            end
            3'b011: begin // State D
                if (~w) next_state = 3'b101; // Transition to F
                else next_state = 3'b000; // Transition to A
            end
            3'b100: begin // State E
                if (~w) next_state = 3'b100; // Stay in E
                else next_state = 3'b011; // Transition to D
            end
            3'b101: begin // State F
                if (~w) next_state = 3'b010; // Transition to C
                else next_state = 3'b011; // Transition to D
            end
            default: next_state = 3'b000; // Default to State A
        endcase
        Y1_reg = next_state[1]; // Directly compute Y1 from next_state
    end

    assign Y1 = Y1_reg;

endmodule