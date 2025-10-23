module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Binary state encoding
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b010,
                     D = 3'b011,
                     E = 3'b100,
                     F = 3'b101;

    reg [2:0] current_state, next_state;

    // Binary decision tree for state transitions
    always @(*) begin
        // Default to current state (self-loop)
        next_state = current_state;
        
        // Decision tree using arithmetic comparisons
        if (current_state == A) begin
            next_state = w ? B : A;
        end else if (current_state == B) begin
            next_state = w ? C : D;
        end else if (current_state == C) begin
            next_state = w ? E : D;
        end else if (current_state == D) begin
            next_state = w ? F : A;
        end else if (current_state == E) begin
            next_state = w ? E : D;
        end else if (current_state == F) begin
            next_state = w ? C : D;
        end
    end

    // State storage with arithmetic reset
    always @(posedge clk) begin
        current_state <= reset ? 3'b000 : next_state;
    end

    // Output logic using bitmask pattern matching
    // z = 1 when state is E (100) or F (101) -> check if bit 2 is set
    assign z = current_state[2];

endmodule