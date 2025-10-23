module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Hybrid state encoding for optimal PPA
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b010,
                     D = 3'b011,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] current_state, next_state;

    // State transition logic (combinational)
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

    // State storage (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - E and F have MSB set (fast path)
    assign z = current_state[2];

endmodule