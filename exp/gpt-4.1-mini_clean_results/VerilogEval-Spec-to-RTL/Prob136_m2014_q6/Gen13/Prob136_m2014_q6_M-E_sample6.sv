module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    // Each bit represents a state: A=000001, B=000010, C=000100, D=001000, E=010000, F=100000
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    always @(*) begin
        // Default to zero next state (shouldn't happen)
        next_state = 6'b0;

        case (state)
            A: next_state = (w == 0) ? B : A;
            B: next_state = (w == 0) ? C : D;
            C: next_state = (w == 0) ? E : D;
            D: next_state = (w == 0) ? F : A;
            E: next_state = (w == 0) ? E : D;
            F: next_state = (w == 0) ? C : D;
            default: next_state = A; // safe default
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is high when state is E or F
    assign z = (state == E) || (state == F);

endmodule