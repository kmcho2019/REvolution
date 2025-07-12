module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Clock gating control
    wire update_en = ~load;
    reg [511:0] next_q;

    // Combinational next state calculation
    always @(*) begin
        // Boundary bits first (simplified handling)
        next_q[511] = (q[511] & ~q[510]) | (~q[511] & q[510]);
        next_q[0] = (q[0] & ~1'b0) | (~q[0] & 1'b0);

        // Main processing (optimized logic)
        for (integer i = 1; i < 511; i = i+1) begin
            wire left = q[i+1];
            wire center = q[i];
            wire right = q[i-1];
            // Optimized to 3 operations: (L^C)|(C&R)|(L&R)
            next_q[i] = (left ^ center) | (center & right) | (left & right);
        end
    end

    // State transition with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (update_en) begin
            q <= next_q;
        end
    end

endmodule