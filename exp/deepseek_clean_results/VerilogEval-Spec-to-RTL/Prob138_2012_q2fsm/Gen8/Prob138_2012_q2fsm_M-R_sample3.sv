module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding (6 states)
    localparam [5:0] A = 6'b000001;
    localparam [5:0] B = 6'b000010;
    localparam [5:0] C = 6'b000100;
    localparam [5:0] D = 6'b001000;
    localparam [5:0] E = 6'b010000;  // z=1
    localparam [5:0] F = 6'b100000;  // z=1

    reg [5:0] current_state;
    reg [5:0] next_state;

    // State transition logic - direct assignments for each state
    always @(*) begin
        next_state = 6'b0;  // Default to catch missing cases
        
        // A transitions
        if (current_state == A)
            next_state = w ? B : A;
        
        // B transitions
        if (current_state == B)
            next_state = w ? C : D;
        
        // C transitions
        if (current_state == C)
            next_state = w ? E : D;
        
        // D transitions
        if (current_state == D)
            next_state = w ? F : A;
        
        // E transitions
        if (current_state == E)
            next_state = w ? E : D;
        
        // F transitions
        if (current_state == F)
            next_state = w ? C : D;
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic - z=1 when in state E or F
    assign z = current_state[4] | current_state[5];

endmodule