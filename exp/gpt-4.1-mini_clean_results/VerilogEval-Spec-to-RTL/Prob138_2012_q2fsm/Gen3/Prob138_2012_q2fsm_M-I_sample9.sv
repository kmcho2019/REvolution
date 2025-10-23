module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding: 6 bits, one per state
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] current_state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (1'b1)  // priority encoding on one-hot current_state
            current_state[A[0] ? 0 : 1 ? 1 : 2 ? 2 : 3 ? 3 : 4 ? 4 : 5]: // incorrect syntax, better use if-else below
        endcase
    end

endmodule