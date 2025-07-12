module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized 3-bit state encoding with output as MSB
    parameter [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b100;

    reg [2:0] current_state, next_state;

    // Parallel transition logic using assign statements
    assign next_state = 
        (current_state == A) ? (w ? B : A) :
        (current_state == B) ? (w ? C : D) :
        (current_state == C) ? (w ? E : D) :
        (current_state == D) ? (w ? F : A) :
        (current_state == E) ? (w ? E : D) :
        (current_state == F) ? (w ? C : D) :
        A;  // Default to A for undefined states

    // State storage with synchronous reset
    always @(posedge clk) begin
        if (reset) current_state <= A;
        else current_state <= next_state;
    end

    // Direct output mapping from state MSB
    assign z = current_state[2];

endmodule