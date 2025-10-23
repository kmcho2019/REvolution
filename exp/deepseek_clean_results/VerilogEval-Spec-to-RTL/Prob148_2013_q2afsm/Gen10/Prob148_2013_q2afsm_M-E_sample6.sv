module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: 
    // 000 - no grant (state A)
    // 001 - g0 granted (state B)
    // 010 - g1 granted (state C)
    // 100 - g2 granted (state D)
    reg [2:0] grant_state;

    // Priority encoder for new grants
    wire [2:0] next_grant;
    assign next_grant = r[0] ? 3'b001 : 
                      (r[1] ? 3'b010 : 
                      (r[2] ? 3'b100 : 3'b000));

    always @(posedge clk) begin
        if (!resetn) begin
            grant_state <= 3'b000; // Reset to state A (no grants)
        end else begin
            case (grant_state)
                3'b000: // State A - no current grant
                    grant_state <= next_grant; // Grant to highest priority request
                
                3'b001: // State B - g0 granted
                    grant_state <= r[0] ? 3'b001 : 3'b000; // Maintain if r0 still active
                
                3'b010: // State C - g1 granted
                    grant_state <= r[1] ? 3'b010 : 3'b000; // Maintain if r1 still active
                
                3'b100: // State D - g2 granted
                    grant_state <= r[2] ? 3'b100 : 3'b000; // Maintain if r2 still active
                
                default: // Should never happen
                    grant_state <= 3'b000;
            endcase
        end
    end

    // Output assignments
    assign g = grant_state;

endmodule