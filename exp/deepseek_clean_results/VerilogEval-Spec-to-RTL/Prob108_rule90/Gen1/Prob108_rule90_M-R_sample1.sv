module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] q_next;

    // Boundary conditions
    assign q_next[0] = 0 ^ q[1];       // Left neighbor is 0
    assign q_next[511] = q[510] ^ 0;    // Right neighbor is 0

    // Middle cells
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : rule90_cells
            assign q_next[i] = q[i-1] ^ q[i+1];
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule