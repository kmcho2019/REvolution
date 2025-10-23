module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// State encoding (3-bit binary encoding for 6 states)
localparam [2:0]
    A = 3'd0,
    B = 3'd1,
    C = 3'd2,
    D = 3'd3,
    E = 3'd4,
    F = 3'd5;

reg [2:0] state, next_state;

// State register: synchronous reset, triggered on posedge clk
always @(posedge clk) begin
    if (reset)
        state <= A;
    else
        state <= next_state;
end

// Next-state logic: combinational block with default assignment to avoid latches
always @(*) begin
    next_state = A; // default safe state (can be changed if desired)
    case (state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A; // safe fallback
    endcase
end

// Output logic: z = 1 only in state E, combinational always block
always @(*) begin
    z = (state == E) ? 1'b1 : 1'b0;
end

endmodule