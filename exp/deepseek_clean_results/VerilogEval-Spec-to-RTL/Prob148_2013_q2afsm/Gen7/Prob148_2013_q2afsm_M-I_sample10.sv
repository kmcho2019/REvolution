module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [2:0] grant_hold; // One-hot encoding: [0] = g0, [1] = g1, [2] = g2
    wire clk_gated;
    wire idle_state = (grant_hold == 3'b000);

    // Clock gating for power optimization
    assign clk_gated = clk & (~idle_state | ~resetn);

    // Priority encoder using case statement
    reg [2:0] next_grant;
    always @(*) begin
        casex (r)
            3'b1xx: next_grant = 3'b001; // Highest priority to r[0]
            3'b01x: next_grant = 3'b010; // Next priority to r[1]
            3'b001: next_grant = 3'b100; // Lowest priority to r[2]
            default: next_grant = 3'b000; // No request
        endcase
    end

    // Grant tracking logic with gated clock
    always @(posedge clk_gated or negedge resetn) begin
        if (!resetn) begin
            grant_hold <= 3'b000;
        end else begin
            case (1'b1) // Synthesis will optimize this case statement
                grant_hold[0]: grant_hold <= r[0] ? 3'b001 : 3'b000;
                grant_hold[1]: grant_hold <= r[1] ? 3'b010 : 3'b000;
                grant_hold[2]: grant_hold <= r[2] ? 3'b100 : 3'b000;
                default: grant_hold <= next_grant;
            endcase
        end
    end

    // Output generation is direct from one-hot state
    assign g = grant_hold;

endmodule