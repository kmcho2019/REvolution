module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0] A = 6'b000001;
    localparam [5:0] B = 6'b000010;
    localparam [5:0] C = 6'b000100;
    localparam [5:0] D = 6'b001000;
    localparam [5:0] E = 6'b010000;
    localparam [5:0] F = 6'b100000;

    reg [5:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        next_state = 6'b0; // Default to avoid latches
        case (1'b1) // Synthesis-safer one-hot case statement
            current_state[A]: next_state = w ? B : A;
            current_state[B]: next_state = w ? C : D;
            current_state[C]: next_state = w ? E : D;
            current_state[D]: next_state = w ? F : A;
            current_state[E]: next_state = w ? E : D;
            current_state[F]: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - z is high in states E or F (bits 4 or 5)
    assign z = current_state[4] | current_state[5];

endmodule