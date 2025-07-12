module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
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
        if (!resetn) begin
            state <= A;
            g <= 3'b000;
        end
        else begin
            state <= next_state;
            // Output logic - only update when state changes
            case (next_state)
                2'b01: g <= 3'b001;
                2'b10: g <= 3'b010;
                2'b11: g <= 3'b100;
                default: g <= 3'b000;
            endcase
        end
    end

    // Priority encoder and next state logic
    always @(*) begin
        case (state)
            A: begin
                if (r[0]) next_state = 2'b01;
                else if (r[1]) next_state = 2'b10;
                else if (r[2]) next_state = 2'b11;
                else next_state = A;
            end
            2'b01: next_state = r[0] ? 2'b01 : A;  // Keep g0 if r0 persists
            2'b10: next_state = r[1] ? 2'b10 : A;  // Keep g1 if r1 persists
            2'b11: next_state = r[2] ? 2'b11 : A;  // Keep g2 if r2 persists
        endcase
    end

endmodule