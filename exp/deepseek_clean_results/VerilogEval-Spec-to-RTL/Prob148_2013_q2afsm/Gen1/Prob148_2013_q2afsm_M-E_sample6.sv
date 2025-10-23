module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [1:0] grant_hold; // 00: no grant, 01: g0, 10: g1, 11: g2

    // Priority encoder and next grant logic
    wire [1:0] next_grant;
    assign next_grant = (r[0]) ? 2'b01 :    // Highest priority
                       (r[1]) ? 2'b10 :    // Medium priority
                       (r[2]) ? 2'b11 :    // Lowest priority
                       2'b00;              // No request

    // Grant tracking logic
    always @(posedge clk) begin
        if (!resetn) begin
            grant_hold <= 2'b00;
        end else begin
            case (grant_hold)
                2'b00: grant_hold <= next_grant; // Take new grant if any
                2'b01: grant_hold <= r[0] ? 2'b01 : 2'b00; // Keep g0 if r0 persists
                2'b10: grant_hold <= r[1] ? 2'b10 : 2'b00; // Keep g1 if r1 persists
                2'b11: grant_hold <= r[2] ? 2'b11 : 2'b00; // Keep g2 if r2 persists
                default: grant_hold <= 2'b00;
            endcase
        end
    end

    // Output generation
    assign g[0] = (grant_hold == 2'b01);
    assign g[1] = (grant_hold == 2'b10);
    assign g[2] = (grant_hold == 2'b11);

endmodule