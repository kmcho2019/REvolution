module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Simple binary state encoding
    localparam [2:0] 
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b010,
        STATE_D = 3'b011,
        STATE_E = 3'b100,
        STATE_F = 3'b101;

    reg [2:0] state;

    // State transitions
    always @(posedge clk) begin
        if (reset)
            state <= STATE_A;
        else case (state)
            STATE_A: state <= w ? STATE_A : STATE_B;
            STATE_B: state <= w ? STATE_D : STATE_C;
            STATE_C: state <= w ? STATE_D : STATE_E;
            STATE_D: state <= w ? STATE_A : STATE_F;
            STATE_E: state <= w ? STATE_D : STATE_E;
            STATE_F: state <= w ? STATE_D : STATE_C;
            default: state <= STATE_A;
        endcase
    end

    // Output logic - z is high in states E (100) or F (101)
    assign z = state[2];

endmodule