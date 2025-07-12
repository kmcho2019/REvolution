module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Create byte masks from enable signals
    wire [15:0] byte_mask = {
        {8{byteena[1]}},  // Upper byte mask (bits 15:8)
        {8{byteena[0]}}   // Lower byte mask (bits 7:0)
    };

    // Combined data input with masking
    wire [15:0] masked_d = d & byte_mask;
    wire [15:0] preserved_q = q & ~byte_mask;

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'h0000;
        end else begin
            // Only update bits where byteena is active
            q <= preserved_q | masked_d;
        end
    end

endmodule