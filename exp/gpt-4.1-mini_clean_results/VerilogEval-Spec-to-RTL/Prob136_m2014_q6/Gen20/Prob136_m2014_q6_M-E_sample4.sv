module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding (6 bits)
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    always @(*) begin
        case (state)
            A: next_state = (w == 1'b0) ? B : A;
            B: next_state = (w == 1'b0) ? C : D;
            C: next_state = (w == 1'b0) ? E : D;
            D: next_state = (w == 1'b0) ? F : A;
            E: next_state = (w == 1'b0) ? E : D;
            F: next_state = (w == 1'b0) ? C : D;
            default: next_state = A;  // safe default on invalid state
        endcase
    end

    // State register update with synchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z is high when in state E or F
    assign z = state[4] | state[5];

endmodule