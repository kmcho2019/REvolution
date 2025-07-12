module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] q_reg;
    wire [511:0] q_next;

    // Compute next state with explicit boundary handling
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule90
            if (i == 0) begin
                // Left boundary: q[-1] = 0
                assign q_next[i] = q_reg[i+1] ^ 1'b0;
            end else if (i == 511) begin
                // Right boundary: q[512] = 0
                assign q_next[i] = 1'b0 ^ q_reg[i-1];
            end else begin
                // Middle cells: normal case
                assign q_next[i] = q_reg[i+1] ^ q_reg[i-1];
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q_reg <= data;
        end else begin
            q_reg <= q_next;
        end
        q <= q_reg;
    end

endmodule