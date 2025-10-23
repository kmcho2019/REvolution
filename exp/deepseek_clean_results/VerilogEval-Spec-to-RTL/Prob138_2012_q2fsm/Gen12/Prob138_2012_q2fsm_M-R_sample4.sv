module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding (same as original)
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] current_state;
    wire [2:0] next_state;

    // Parallel state transition logic using ternary operators
    assign next_state = 
        (current_state == A) ? (w ? B : A) :
        (current_state == B) ? (w ? C : D) :
        (current_state == C) ? (w ? E : D) :
        (current_state == D) ? (w ? F : A) :
        (current_state == E) ? (w ? E : D) :
        (current_state == F) ? (w ? C : D) :
        A;  // Default case (should never be needed with proper reset)

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - z is high when in states E or F (bit 2 set)
    assign z = current_state[2];

endmodule