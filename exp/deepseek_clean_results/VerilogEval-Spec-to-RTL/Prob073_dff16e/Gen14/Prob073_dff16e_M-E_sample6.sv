module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Generate individual DFFs with proper enable control
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : dff_array
            // Determine which byte this bit belongs to
            wire bit_enable = (i < 8) ? byteena[0] : byteena[1];
            
            // Instantiate individual DFF
            reg dff;
            always @(posedge clk) begin
                if (!resetn) begin
                    dff <= 1'b0;
                end else if (bit_enable) begin
                    dff <= d[i];
                end
            end
            
            assign q[i] = dff;
        end
    endgenerate

endmodule