module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // State encoding (3 bits for 6 states)
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state, next_state;

    // State flip-flops with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic (Moore FSM)
    always @(*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;  // Safe default
        endcase
    end

    // Output logic: registered output for glitch-free output
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= (state == E) || (state == F);
    end

endmodule