module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    // Generate individual enable signals from byteena
    wire [15:0] bit_enable;
    assign bit_enable[15:8] = {8{byteena[1]}};  // Upper byte mask
    assign bit_enable[7:0]  = {8{byteena[0]}};  // Lower byte mask

    // Array of 16 DFFs with individual enables
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : dff_array
            reg q_bit;
            
            always @(posedge clk) begin
                if (!resetn) begin
                    q_bit <= 1'b0;
                end
                else if (bit_enable[i]) begin
                    q_bit <= d[i];
                end
            end
            
            assign q[i] = q_bit;
        end
    endgenerate

endmodule