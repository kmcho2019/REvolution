module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding for states: bit 0 = A, bit 1 = B, ..., bit 5 = F
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic combinational
    always @(*) begin
        case (1'b1) // one-hot case statement
            state[0]: // A
                next_state = (w) ? B : A;
            state[1]: // B
                next_state = (w) ? C : D;
            state[2]: // C
                next_state = (w) ? E : D;
            state[3]: // D
                next_state = (w) ? F : A;
            state[4]: // E
                next_state = (w) ? E : D;
            state[5]: // F
                next_state = (w) ? C : D;
            default:
                next_state = A; // safe default
        endcase
    end

    // Output is 1 only in state E (bit 4)
    assign z = state[4];

endmodule