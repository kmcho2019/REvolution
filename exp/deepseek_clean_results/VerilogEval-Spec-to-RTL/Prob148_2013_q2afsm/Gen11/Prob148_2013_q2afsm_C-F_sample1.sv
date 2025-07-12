module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    reg [1:0] state, next_state;

    // Priority evaluation (combinational)
    wire grant0_req, grant1_req, grant2_req;
    assign grant0_req = r[0];                     // Highest priority
    assign grant1_req = ~r[0] & r[1];             // Medium priority
    assign grant2_req = ~r[0] & ~r[1] & r[2];     // Lowest priority

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (grant0_req)
                    next_state = B;
                else if (grant1_req)
                    next_state = C;
                else if (grant2_req)
                    next_state = D;
                else
                    next_state = A;
            end
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

    // Output assignments (combinational)
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
               3'b000;

endmodule