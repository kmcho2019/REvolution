module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Binary state encoding
    localparam [2:0] A = 3'b000;
    localparam [2:0] B = 3'b001;
    localparam [2:0] C = 3'b010;
    localparam [2:0] D = 3'b011;
    localparam [2:0] E = 3'b100;
    localparam [2:0] F = 3'b101;

    reg [2:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - z is 1 for states E and F (binary 100 and 101)
    assign z = (current_state == E) | (current_state == F);

endmodule