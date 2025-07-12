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

    // Priority encoder using casez for better timing
    wire [2:0] next_grant;
    always @(*) begin
        casez (r)
            3'b1??: next_grant = 3'b001; // r[0] has highest priority
            3'b01?: next_grant = 3'b010; // then r[1]
            3'b001: next_grant = 3'b100; // then r[2]
            default: next_grant = 3'b000; // no requests
        endcase
    end

    always @(posedge clk) begin
        if (!resetn) begin
            grant_state <= 3'b000; // Reset to state A (no grants)
        end else begin
            case (grant_state)
                3'b000: // State A - no current grant
                    if (|r) grant_state <= next_grant; // Only update if there's a request
                
                3'b001: // State B - g0 granted
                    if (!r[0]) grant_state <= 3'b000; // Only update if r0 drops
                
                3'b010: // State C - g1 granted
                    if (!r[1]) grant_state <= 3'b000; // Only update if r1 drops
                
                3'b100: // State D - g2 granted
                    if (!r[2]) grant_state <= 3'b000; // Only update if r2 drops
            endcase
        end
    end

    // Output assignments remain direct mapping
    assign g = grant_state;

endmodule