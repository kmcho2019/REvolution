module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding with meaningful names
    localparam A = 2'b00,  // Idle state (no grants)
               B = 2'b01,  // Grant to device 0 (g0)
               C = 2'b10,  // Grant to device 1 (g1)
               D = 2'b11;  // Grant to device 2 (g2)
    
    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;  // Reset to idle state
        end else begin
            case (state)
                A: begin  // Idle state - evaluate requests with priority
                    if (r[0])       state <= B;  // Highest priority
                    else if (r[1]) state <= C;
                    else if (r[2]) state <= D;
                end
                B: state <= r[0] ? B : A;  // Keep grant if request persists
                C: state <= r[1] ? C : A;
                D: state <= r[2] ? D : A;
            endcase
        end
    end

    // Output assignments - only one can be active at a time
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);

endmodule