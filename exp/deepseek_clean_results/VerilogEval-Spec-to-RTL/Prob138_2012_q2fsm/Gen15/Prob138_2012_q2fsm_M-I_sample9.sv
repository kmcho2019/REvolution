module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized state encoding with improved output logic
    (* syn_encoding = "gray" *)
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b111,
                     F = 3'b101;

    reg [2:0] current_state, next_state;

    // State transition logic with flattened conditionals
    always @(*) begin
        (* parallel_case *)
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

    // State storage with optimized reset
    always @(posedge clk) begin
        if (reset) current_state <= A;
        else current_state <= next_state;
    end

    // Simplified output logic - E and F have either bit 2 or 1 set
    assign z = current_state[2] | current_state[1];

endmodule