module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding using localparams for clarity and maintainability
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state, next_state;

    // Sequential logic: synchronous reset, update state on positive edge
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next-state logic using case statement for clarity and synthesis friendliness
    always @(*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // Output logic: z=1 only in states E (100) and F (101)
    // Use bitwise expression to minimize combinational complexity
    assign z = (state[2] & ~state[1]);

endmodule