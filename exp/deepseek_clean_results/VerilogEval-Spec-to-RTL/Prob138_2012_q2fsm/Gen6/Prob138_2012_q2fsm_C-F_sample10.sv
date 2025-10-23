module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized binary state encoding with minimal transitions
    // States with z=1 (E,F) grouped with MSB=1
    localparam [2:0] A = 3'b000;  // Reset state
    localparam [2:0] B = 3'b001;  // 1 transition from A
    localparam [2:0] C = 3'b011;  // 1 transition from B
    localparam [2:0] D = 3'b010;  // Common target, central state
    localparam [2:0] E = 3'b110;  // z=1 state
    localparam [2:0] F = 3'b111;  // z=1 state

    reg [2:0] current_state;
    reg [2:0] next_state;

    // State transition logic - direct combinatorial
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;  // Safe recovery
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - z=1 for states E (110) and F (111)
    assign z = current_state[2];  // MSB indicates z=1 states

endmodule