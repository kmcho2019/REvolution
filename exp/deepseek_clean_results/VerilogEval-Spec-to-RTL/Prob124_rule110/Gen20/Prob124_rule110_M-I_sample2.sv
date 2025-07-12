module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;
    wire clk_gated = clk & (~load); // Clock gating when not loading

    // Boundary cells (first and last) handled separately
    // First bit (i=0)
    assign next_q[0] = (q[0] ^ (1'b0 | q[1])) & (1'b0 | q[0] | q[1]);

    // Main cells (i=1 to 510)
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : main_cells
            wire left = q[i+1];
            wire center = q[i];
            wire right = q[i-1];
            // Optimized Rule 110 expression
            assign next_q[i] = (center ^ (left | right)) & (left | center | right);
        end
    endgenerate

    // Last bit (i=511)
    assign next_q[511] = (q[511] ^ (1'b0 | q[510])) & (1'b0 | q[511] | q[510]);

    // State transition logic with clock gating
    always @(posedge clk_gated, posedge load) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule