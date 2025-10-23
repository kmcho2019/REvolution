module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Create extended version of q with boundary conditions
    wire [513:0] extended_q = {1'b0, q, 1'b0};

    // Generate next state for each bit
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Get neighbors from extended version
            wire left = extended_q[i+2];
            wire center = extended_q[i+1];
            wire right = extended_q[i];

            // Optimized Rule 110 logic - more compact expression
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