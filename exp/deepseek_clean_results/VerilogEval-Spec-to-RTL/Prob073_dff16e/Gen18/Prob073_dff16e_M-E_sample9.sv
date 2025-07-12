module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Generate 16-bit write mask from 2-bit byteena
    wire [15:0] write_mask = {
        {8{byteena[1]}},  // Upper byte mask
        {8{byteena[0]}};  // Lower byte mask

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;  // Synchronous active-low reset
        end else begin
            // Conditional update using bitwise operations
            q <= (d & write_mask) | (q & ~write_mask);
        end
    end

endmodule