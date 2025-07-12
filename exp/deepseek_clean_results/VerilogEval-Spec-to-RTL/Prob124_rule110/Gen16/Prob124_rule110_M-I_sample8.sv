module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Left boundary cell (i=0)
    assign next_q[0] = (~q[1] & (q[0] | 1'b0)) | (q[0] & 1'b0);  // right neighbor is 0

    // Middle cells (i=1 to 510)
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : rule110
            // Optimized Rule 110 logic
            assign next_q[i] = (~q[i+1] & (q[i] | q[i-1])) | (q[i] & q[i-1]);
        end
    endgenerate

    // Right boundary cell (i=511)
    assign next_q[511] = (~1'b0 & (q[511] | q[510])) | (q[511] & q[510]);  // left neighbor is 0

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule