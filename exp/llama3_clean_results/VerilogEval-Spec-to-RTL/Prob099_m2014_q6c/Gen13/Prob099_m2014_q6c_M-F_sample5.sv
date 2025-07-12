module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    reg [5:0] next_state;

    always @(*) begin
        case (1'b1)
            y[0]: next_state = w? 6'b000001 : 6'b000010; // State A
            y[1]: next_state = w? 6'b001000 : 6'b000100; // State B
            y[2]: next_state = w? 6'b001000 : 6'b010000; // State C
            y[3]: next_state = w? 6'b000001 : 6'b011111; // State D
            y[4]: next_state = w? 6'b001000 : 6'b010000; // State E
            y[5]: next_state = w? 6'b001000 : 6'b000100; // State F
        endcase
    end

    assign Y1 = next_state[0]; // y[0] corresponds to state A
    assign Y2 = next_state[1]; // y[1] corresponds to state B
    assign Y3 = next_state[2]; // y[2] corresponds to state C
    assign Y4 = next_state[3]; // y[3] corresponds to state D

endmodule