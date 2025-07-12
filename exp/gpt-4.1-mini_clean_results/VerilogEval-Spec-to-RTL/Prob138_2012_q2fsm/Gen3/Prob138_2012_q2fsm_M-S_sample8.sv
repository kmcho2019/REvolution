module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding (binary)
    // A = 3'b000
    // B = 3'b001
    // C = 3'b010
    // D = 3'b011
    // E = 3'b100
    // F = 3'b101

    reg [2:0] current_state, next_state;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= 3'b000; // A
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            3'b000: next_state = w ? 3'b001 : 3'b000; // A
            3'b001: next_state = w ? 3'b010 : 3'b011; // B
            3'b010: next_state = w ? 3'b100 : 3'b011; // C
            3'b011: next_state = w ? 3'b101 : 3'b000; // D
            3'b100: next_state = w ? 3'b100 : 3'b011; // E
            3'b101: next_state = w ? 3'b010 : 3'b011; // F
            default: next_state = 3'b000; // fallback to A
        endcase
    end

    // Output z: 1 when state is E(100) or F(101)
    assign z = (current_state == 3'b100) || (current_state == 3'b101);

endmodule