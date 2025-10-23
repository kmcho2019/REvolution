module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Optimized state encoding: 
    // 000 - Idle (A)
    // 001 - Grant to r0 (B)
    // 010 - Grant to r1 (C)
    // 100 - Grant to r2 (D)
    localparam A = 3'b000;
    reg [2:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    // Priority encoder and next state logic
    always @(*) begin
        case (state)
            A: begin
                next_state = r[0] ? 3'b001 :    // Highest priority
                             r[1] ? 3'b010 :    // Medium priority
                             r[2] ? 3'b100 :    // Lowest priority
                             3'b000;            // No request
            end
            3'b001: next_state = r[0] ? 3'b001 : 3'b000; // Keep g0 if r0 persists
            3'b010: next_state = r[1] ? 3'b010 : 3'b000; // Keep g1 if r1 persists
            3'b100: next_state = r[2] ? 3'b100 : 3'b000; // Keep g2 if r2 persists
            default: next_state = 3'b000;
        endcase
    end

    // Output logic - direct mapping from state bits
    assign g = state;

endmodule