module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin: bit_slice
        // Determine if this bit should be enabled
        wire bit_enable = (i < 8) ? byteena[0] : byteena[1];
        
        // Individual bit storage element
        always @(posedge clk) begin
            if (!resetn) begin
                q[i] <= 1'b0;
            end else if (bit_enable) begin
                q[i] <= d[i];
            end
        end
    end
endgenerate

endmodule