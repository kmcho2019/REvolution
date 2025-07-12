module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Simplified state encoding
    localparam A = 1'b0,
               B = 1'b1,
               C = 1'b1; // Same encoding as B but differentiated by output

    reg state; // 0=A, 1=grant state (B or C)
    reg is_b;  // 1=B, 0=C when in grant state

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            is_b <= 1'b0;
        end
        else begin
            state <= (state == A) ? 
                    (r[0] ? 1'b1 : (r[1] ? 1'b1 : A)) : // Enter grant state
                    ((is_b & r[0]) | (~is_b & r[1]) ? state : A); // Stay or return
                    
            is_b <= (state == A) ? r[0] : is_b; // Set grant type
        end
    end

    // Simplified output logic
    assign g = {1'b0, ~is_b & state, is_b & state};

endmodule