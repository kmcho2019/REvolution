module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    // Define byte masks based on byte enables
    wire [7:0] mask_upper = {8{byteena[1]}};
    wire [7:0] mask_lower = {8{byteena[0]}};

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Update each byte selectively using masking
            q[15:8] <= (q[15:8] & ~mask_upper) | (d[15:8] & mask_upper);
            q[7:0]  <= (q[7:0]  & ~mask_lower) | (d[7:0]  & mask_lower);
        end
    end

endmodule