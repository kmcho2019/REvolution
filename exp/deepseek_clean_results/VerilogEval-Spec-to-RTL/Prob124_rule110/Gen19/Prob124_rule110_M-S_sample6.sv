module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];

            // Simplified Rule 110 logic:
            // Next state is 1 when:
            // - Center is 1 and left is 0, OR
            // - Right is 1 and left is 0, OR
            // - Center is 1 and right is 0
            assign next_q[i] = (center & ~left) | (right & ~left) | (center & ~right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule