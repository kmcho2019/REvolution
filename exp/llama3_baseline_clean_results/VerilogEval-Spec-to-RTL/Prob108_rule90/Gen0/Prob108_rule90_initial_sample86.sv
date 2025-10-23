module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (int i = 0; i < 512; i++) begin
                if (i == 0) begin
                    // Handle left boundary
                    q[i] <= q[i + 1];
                end else if (i == 511) begin
                    // Handle right boundary
                    q[i] <= q[i - 1];
                end else begin
                    // Apply Rule 90
                    q[i] <= q[i - 1] ^ q[i + 1];
                end
            end
        end
    end

endmodule