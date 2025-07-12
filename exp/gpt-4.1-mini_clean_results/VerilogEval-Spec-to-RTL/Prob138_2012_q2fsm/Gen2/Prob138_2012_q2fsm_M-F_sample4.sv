module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding (binary)
    localparam A = 3'd0;
    localparam B = 3'd1;
    localparam C = 3'd2;
    localparam D = 3'd3;
    localparam E = 3'd4;
    localparam F = 3'd5;

    reg [2:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic combinational
    always @(*) begin
        next_state = A; // default to safe state to avoid inferred latches
        case(state)
            A: next_state = (w) ? B : A;
            B: next_state = (w) ? C : D;
            C: next_state = (w) ? E : D;
            D: next_state = (w) ? F : A;
            E: next_state = (w) ? E : D;
            F: next_state = (w) ? C : D;
            default: next_state = A; // safe default if invalid state occurs
        endcase
    end

    // Output asserted only in state E
    assign z = (state == E);

endmodule