module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input   [15:0] d,
    output  reg [15:0] q
);

    // Create masks for upper and lower bytes based on byteena
    wire [15:0] mask_upper = {8{byteena[1]}};
    wire [15:0] mask_lower = {8{byteena[0]}};
    wire [15:0] mask = (mask_upper << 8) | mask_lower;

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Update only bytes enabled by byteena, preserve others
            q <= (q & ~mask) | (d & mask);
        end
    end

endmodule