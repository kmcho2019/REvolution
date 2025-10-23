module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Temporary extended register for boundary handling
    wire [513:0] extended_q = {1'b0, q, 1'b0};

    // Generate next state for each bit
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Get neighbors from extended register
            wire left = extended_q[i+2];
            wire center = extended_q[i+1];
            wire right = extended_q[i];

            // Optimized Rule 110 logic:
            // Equivalent to: (center ^ right) | (center & left)
            assign next_q[i] = (center != right) | (center & left);
        end
    endgenerate

    // State transition logic with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Only update cells that will change state
            q <= next_q;
        end
    end

endmodule