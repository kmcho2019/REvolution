module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Binary state encoding where MSB = z output
    localparam [2:0] A = 3'b000,
                     B = 3'b000,
                     C = 3'b000,
                     D = 3'b000,
                     E = 3'b100,
                     F = 3'b101;

    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    assign z = state[2];

endmodule