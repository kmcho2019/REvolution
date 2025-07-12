module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Next state logic
    wire [511:0] next_q;

    // Generate next state for each bit with optimized boundary handling
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Handle boundary cases (q[-1] and q[512] are 0)
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];

            // Optimized Rule 110 logic - compact XOR-based expression
            assign next_q[i] = (center ^ (left & right)) | (~left & right);
        end
    endgenerate

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule