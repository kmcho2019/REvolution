module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray-coded state encoding to minimize transitions
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] current_state, next_state;

    // Case statement for better synthesis and timing
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A; // Handle unused states
        endcase
    end

    // State storage with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic - now checking two bits for states E and F
    assign z = (current_state == E) | (current_state == F);

endmodule