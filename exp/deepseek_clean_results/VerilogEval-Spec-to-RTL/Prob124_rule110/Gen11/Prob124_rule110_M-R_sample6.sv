module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    wire [513:0] padded_q = {1'b0, q, 1'b0}; // Pad with boundary conditions

    always @(*) begin
        for (integer i = 0; i < 512; i = i + 1) begin
            // Get neighbors from padded version
            wire left = padded_q[i+2];
            wire center = padded_q[i+1];
            wire right = padded_q[i];
            
            // Optimized Rule 110 logic
            next_q[i] = (center ^ right) | (~left & (center | right));
        end
    end

    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule