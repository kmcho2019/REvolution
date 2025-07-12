module TopModule(
    input [7:0] in,
    output parity
);

    wire [3:0] mid_parity;
    
    assign mid_parity[0] = in[0] ^ in[1];
    assign mid_parity[1] = in[2] ^ in[3];
    assign mid_parity[2] = in[4] ^ in[5];
    assign mid_parity[3] = in[6] ^ in[7];
    
    wire [1:0] final_parity;
    
    assign final_parity[0] = mid_parity[0] ^ mid_parity[1];
    assign final_parity[1] = mid_parity[2] ^ mid_parity[3];
    
    assign parity = final_parity[0] ^ final_parity[1];

endmodule