module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding with meaningful names
    localparam A = 2'b00,  // No grant
               B = 2'b01,  // g0 granted
               C = 2'b10,  // g1 granted
               D = 2'b11;  // g2 granted
    
    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;  // Reset to idle state
        end else begin
            case (state)
                A: begin  // No current grant
                    if (r[0]) state <= B;       // Highest priority
                    else if (r[1]) state <= C;   // Medium priority
                    else if (r[2]) state <= D;   // Lowest priority
                end
                B: state <= r[0] ? B : A;  // Maintain g0 if r0 active
                C: state <= r[1] ? C : A;  // Maintain g1 if r1 active
                D: state <= r[2] ? D : A;  // Maintain g2 if r2 active
            endcase
        end
    end

    // Output assignments - direct mapping from state
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);

endmodule