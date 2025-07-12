module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    // Create byte enable masks
    wire [15:0] byte_mask = {
        {8{byteena[1]}},  // Upper byte mask
        {8{byteena[0]}}   // Lower byte mask
    };

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Apply byte enables using bitwise masking
            q <= (d & byte_mask) | (q & ~byte_mask);
        end
    end

endmodule