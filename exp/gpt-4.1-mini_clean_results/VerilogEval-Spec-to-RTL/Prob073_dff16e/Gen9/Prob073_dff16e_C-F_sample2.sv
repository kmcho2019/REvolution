module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    // Generate 8-bit masks per byte based on byteena bits
    wire [7:0] mask_upper = byteena[1] ? 8'hFF : 8'h00;
    wire [7:0] mask_lower = byteena[0] ? 8'hFF : 8'h00;
    wire [15:0] mask = {mask_upper, mask_lower};

    // Clock enable to avoid updates when no bytes are enabled
    wire clk_en = |byteena;

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else if (clk_en) begin
            // Update only enabled bytes using mask; preserve others
            q <= (q & ~mask) | (d & mask);
        end
        // else retain previous q without toggling
    end

endmodule