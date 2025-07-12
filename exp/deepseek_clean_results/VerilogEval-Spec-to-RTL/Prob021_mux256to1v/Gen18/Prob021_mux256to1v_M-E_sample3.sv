module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Barrel shifter implementation
    wire [1023:0] shifted [0:7];
    
    // Initial stage
    assign shifted[0] = sel[0] ? {in[1023-4:0], in[1023:1020]} : in;
    
    // Subsequent stages
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : shift_stages
            assign shifted[i] = sel[i] ? {shifted[i-1][1023-(4<<i):0], shifted[i-1][1023:1024-(4<<i)]} : shifted[i-1];
        end
    endgenerate

    // Output is the first 4 bits after shifting
    assign out = shifted[7][3:0];

endmodule