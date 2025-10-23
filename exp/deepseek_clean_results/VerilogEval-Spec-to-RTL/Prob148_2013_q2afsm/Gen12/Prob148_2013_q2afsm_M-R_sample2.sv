module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding with meaningful names
    parameter A = 2'b00,  // No grant
              B = 2'b01,  // g0 granted
              C = 2'b10,  // g1 granted
              D = 2'b11;  // g2 granted
    
    reg [1:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            A: begin  // No current grant
                if (r[0])       next_state = B;  // Highest priority
                else if (r[1])  next_state = C;  // Medium priority
                else if (r[2])  next_state = D;  // Lowest priority
                else            next_state = A;
            end
            B: next_state = r[0] ? B : A;  // Maintain g0 if r0 active
            C: next_state = r[1] ? C : A;  // Maintain g1 if r1 active
            D: next_state = r[2] ? D : A;  // Maintain g2 if r2 active
            default: next_state = A;
        endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk) begin
        if (!resetn) state <= A;  // Synchronous reset
        else state <= next_state;
    end

    // Output assignments - direct mapping from state
    assign g = {(state == D), (state == C), (state == B)};

endmodule