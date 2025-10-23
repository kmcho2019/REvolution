module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    // Generate Rule 90 logic for each cell
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90
            always @(*) begin
                if (i == 0) begin
                    // Left boundary: left neighbor is 0
                    next_q[i] = 0 ^ q[i+1];
                end else if (i == 511) begin
                    // Right boundary: right neighbor is 0
                    next_q[i] = q[i-1] ^ 0;
                end else begin
                    // Normal case: XOR left and right neighbors
                    next_q[i] = q[i-1] ^ q[i+1];
                end
            end
        end
    endgenerate

    // Synchronous update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule