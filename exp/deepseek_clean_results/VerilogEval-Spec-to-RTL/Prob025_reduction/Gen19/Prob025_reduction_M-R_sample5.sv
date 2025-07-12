module TopModule (
    input [7:0] in,
    output parity
);
    wire [7:0] partial;
    
    assign partial[0] = in[0];
    
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : parity_calc
            assign partial[i] = partial[i-1] ^ in[i];
        end
    endgenerate
    
    assign parity = partial[7];
endmodule