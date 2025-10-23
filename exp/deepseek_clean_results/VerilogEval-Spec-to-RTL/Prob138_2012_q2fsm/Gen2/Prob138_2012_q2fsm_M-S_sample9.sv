module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Define states using simple binary encoding
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b010,
                     D = 3'b011,
                     E = 3'b100,
                     F = 3'b101;

    reg [2:0] current_state, next_state;

    // State storage (sequential logic)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // State transitions (combinational logic)
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

    // Output logic (z is 1 in states E and F)
    assign z = (current_state == E) || (current_state == F);

endmodule