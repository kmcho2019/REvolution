module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Middle cells (1-510)
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : middle_cells
            // Optimized Rule 110 logic: q ^ (left | (q & right))
            assign next_q[i] = q[i] ^ (q[i+1] | (q[i] & q[i-1]));
        end
    endgenerate

    // Left boundary (cell 0)
    assign next_q[0] = q[0] ^ (q[1] | (q[0] & 1'b0));

    // Right boundary (cell 511)
    assign next_q[511] = q[511] ^ (1'b0 | (q[511] & q[510]));

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule