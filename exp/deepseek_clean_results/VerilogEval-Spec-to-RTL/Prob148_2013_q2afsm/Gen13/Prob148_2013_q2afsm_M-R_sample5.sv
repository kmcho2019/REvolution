module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Binary state encoding:
    // 00 - Idle (A)
    // 01 - Grant to r0 (B)
    // 10 - Grant to r1 (C)
    // 11 - Grant to r2 (D)
    localparam A = 2'b00;
    reg [1:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    // Next state logic using structured if-else
    always @(*) begin
        next_state = A;  // Default to idle state
        
        if (state == A) begin
            if (r[0]) next_state = 2'b01;    // Highest priority
            else if (r[1]) next_state = 2'b10; // Medium priority
            else if (r[2]) next_state = 2'b11; // Lowest priority
        end
        else begin
            // Persist in current state if request continues
            case (state)
                2'b01: if (r[0]) next_state = 2'b01; // Keep g0 if r0 persists
                2'b10: if (r[1]) next_state = 2'b10; // Keep g1 if r1 persists
                2'b11: if (r[2]) next_state = 2'b11; // Keep g2 if r2 persists
            endcase
        end
    end

    // Explicit output assignments
    assign g[0] = (state == 2'b01);
    assign g[1] = (state == 2'b10);
    assign g[2] = (state == 2'b11);

endmodule